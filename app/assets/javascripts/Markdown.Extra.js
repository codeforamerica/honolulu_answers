(function () {
  Markdown.Extra = function() {

    // For converting internal markdown (in tables for instance).
    // This is necessary since these methods are meant to be called as
    // preConversion hooks, and the Markdown converter passed to init()
    // won't convert any markdown contained in the html tags we return.
    this.sanitizingConverter = Markdown.getSanitizingConverter();

    // Stores html blocks we generate in preConversion hooks so that
    // they're not destroyed if the user is using a sanitizing converter
    this.hashBlocks = [];

    // Fenced code block options
    this.googleCodePrettify = false;
    this.highlightJs = false;

    // Table options
    this.tableClass = 'wmd-table';
  };


  Markdown.Extra.init = function(converter, options) {
    // Each call to init creates a new instance of Markdown.Extra so it's
    // safe to have multiple converters on a single page
    var extra = new Markdown.Extra();

    options = options || {};
    options.extensions = options.extensions || [];
    if (options.extensions.length === 0 || options.extensions.indexOf("all") != -1) {
      converter.hooks.chain("preConversion", function(text) {
        return extra.all(text);
      });
    } else {
      if (options.extensions.indexOf("tables") != -1) {
        converter.hooks.chain("preConversion", function(text) {
          return extra.tables(text);
        });
      }
      if (options.extensions.indexOf("fencedCodeBlocks") != -1) {
        converter.hooks.chain("preConversion", function(text) {
          return extra.fencedCodeBlocks(text);
        });
      }
    }

    converter.hooks.chain("postConversion", function(text) {
      return extra.unHashBlocks(text);
    });

    if (typeof options.highlighter != "undefined") {
        extra.googleCodePrettify = options.highlighter === 'prettify';
        extra.highlightJs = options.highlighter === 'highlight';
    }

    if (typeof options.tableClass != "undefined") {
        extra.tableClass = options.tableClass;
    }

    // Caller usually won't need this, but it's handy for testing.
    return extra;
  };

  function strip(str) {
    return str.replace(/^\s+|\s+$/g, '');
  }

  function contains(str, substr) {
    return str.indexOf(substr) != -1;
  }

  // Returns the tag if it matches the whitelist, else return empty string
  function sanitizeTag(tag, whitelist) {
    if (tag.match(whitelist))
      return tag;
    return '';
  }

  // Sanitizes html, removing tags that aren't in the whitelist
  function sanitizeHtml(html, whitelist) {
    return html.replace(/<[^>]*>?/gi, function(match) {
      return sanitizeTag(match, whitelist);
    });
  }

  // Replace `block` in `text` with a placeholder containing a key,
  // where the key is the block's index in the hashBlocks array.
  Markdown.Extra.prototype.hashBlock = function(text, block) {
    var key = this.hashBlocks.push(block) - 1;
    var rep = '<p>{{wmd-block-key=' + key + '}}</p>';
    return text.replace(block, rep);
  };

  // Replace placeholder blocks in `text` with their corresponding
  // html blocks in the hashBlocks array.
  Markdown.Extra.prototype.unHashBlocks = function(text) {
    var re = new RegExp('<p>{{wmd-block-key=(\\d+)}}</p>', 'gm');
    while(match = re.exec(text)) {
      key = parseInt(match[1], 10);
      text = text.replace(match[0], this.hashBlocks[key]);
    }
    return text;
  };

  // Find and convert Markdown Extra tables into html.
  Markdown.Extra.prototype.tables = function(text) {
    // Whitelist used as a post-processing step after calling convert.makeHtml()
    // to keep only span-level tags inside tables per the PHP Markdown Extra spec.
    var whitelist = /^(<\/?(b|del|em|i|s|sup|sub|strong|strike)>|<(br)\s?\/?>)$/i;
    var that = this;

    // Convert markdown withing the table, retaining only span-level tags
    function convertInline(text) {
      var html = that.sanitizingConverter.makeHtml(text);
      return sanitizeHtml(html, whitelist);
    }

    // Split a row into columns
    function splitRow(row, border) {
      var r = strip(row);
      // remove initial/final pipes if they exist
      if (border) {
        if (r.indexOf('|') === 0)
          r = r.slice(1);
        if (r.lastIndexOf('|') === r.length - 1)
          r = r.slice(0, -1);
      }

      var cols = r.split('|');
      for (var i = 0; i < cols.length; i++)
        cols[i] = strip(cols[i]);

      return cols;
    }

    // Convert a single row of a markdown table into html.
    function buildRow(line, border, align, isHeader) {
      var rowHtml = '<tr>';
      var cols = splitRow(line, border);
      var style, cellStart, cellEnd, content;

      // Use align to ensure each row has same number of columns
      for (var i = 0; i < align.length; i++) {
        style = align[i] && !isHeader ? ' style="text-align:' + align[i] + ';"' : '';
        cellStart = isHeader ? '<th'+style+'>' : '<td'+style+'>';
        cellEnd = isHeader ? "</th>" : "</td>";
        content = i < cols.length ? convertInline(cols[i]) : '';
        rowHtml += cellStart + content + cellEnd;
      }

      return rowHtml + "</tr>";
    }

    function isTableRow(line, ndx) {
      var pipes = line.match(/\|/g);
      var escapedPipes = line.match(/\\\|/g);
      var pCount = pipes === null ? 0 : pipes.length;
      var epCount = escapedPipes === null ? 0 : escapedPipes.length;
      // if all pipes are escaped, then we don't interpret it as a table row
      if (pCount == epCount)
        return false;

      if (ndx == 1 && pCount > 0)
        return contains(line, '-');

      return pCount > 0;
    }

    // Find next block (group of lines matching our definition of a table) in `text`
    function findNextBlock(text) {
      var lines = text.split('\n');
      var block = [], ndx = 0, bounds = {};
      for (var i = 0; i < lines.length; i++) {
        var line = lines[i];
        // TODO: ignore within gfm code blocks and all block-level tags
        if (isTableRow(line, ndx)) {
            if (typeof bounds.start == "undefined")
              bounds.start = i;
            block.push(line);
            ndx++;
        } else { // invalid line
          if (block.length < 3) { // valid table needs head, sep, body
            // reset and continue
            block = [];
            bounds = {};
            ndx = 0;
          } else {
            break;
          }
        }
      }

      // this is outside the for loop b/c it's possble that we
      // never ran into an invalid line -- i.e. block ends at end of text
      if (block.length >= 3) {
          bounds.end = bounds.start + block.length;
          return {block: block, bounds: bounds, lines: lines};
      }

      return null;
    }

    function makeTables(text) {
      var blockdata;
      while ((blockdata = findNextBlock(text)) !== null) {
        var block = blockdata.block,
            bounds = blockdata.bounds,
            lines = blockdata.lines,
            header = strip(block[0]),
            sep = strip(block[1]),
            border = false;

        if (header.indexOf('|') === 0 ||
            header.lastIndexOf('|') === header.length-1)
          border = true;

        var align = [],
            cols = splitRow(sep, border);

        // determine alignment of columns
        for (var j = 0; j < cols.length; j++) {
          var c = cols[j];
          if (c.indexOf(':') === 0 && c.lastIndexOf(':') == c.length - 1)
            align.push('center');
          else if (c.indexOf(':') === 0)
            align.push('left');
          else if (c.lastIndexOf(':') === c.length - 1)
            align.push('right');
          else
            align.push(null);
        }

        // build html.
        var cls = that.tableClass === '' ? '' :
          ' class="' + that.tableClass + '"';
        var head = buildRow(block[0], border, align, true);

        var tableHtml = ['<table', cls, '>', head].join('');
        for (j = 2; j < block.length; j++)
          tableHtml += buildRow(block[j], border, align, false);
        tableHtml += "</table>\n";

        // replace table markdown with html
        var toRemove = bounds.end - bounds.start + 1;
        lines.splice(bounds.start, toRemove, tableHtml);

        // replace html with placeholder until postConversion step
        text = lines.join('\n');
        text = that.hashBlock(text, tableHtml);
      }

      return text;
    }

    return makeTables(text);
  };

  // Find and convert gfm-inspired fenced code blocks into html.
  Markdown.Extra.prototype.fencedCodeBlocks = function(text) {
    function encodeCode(code) {
      code = code.replace(/&/g, "&amp;");
      code = code.replace(/</g, "&lt;");
      code = code.replace(/>/g, "&gt;");
      return code;
    }

    // TODO: ignore within block-level tags
    var re = new RegExp(
      '(\\n\\n|^\\n?)' +      // separator, $1 = leading whitespace
      '^```(\\w+)?\\s*\\n' +  // opening fence, $2 = optional lang
      '([\\s\\S]*?)' +        // $3 = code block content (no dotAll in js - dot doesn't match newline)
      '^```\\s*\\n',          // closing fence
      'gm'                    // Flags : global, multiline
    );

    var match;
    while (match = re.exec(text)) {
      var preclass = this.googleCodePrettify ? ' class="prettyprint"' : '';
      var codeclass = '';
      if (typeof match[2] != "undefined" && (this.googleCodePrettify || this.highlightJs))
        codeclass = ' class="language-' + match[2] + '"';
      var codeblock = '<pre' + preclass + '><code' + codeclass + '>';
      codeblock += encodeCode(match[3]) + '</code></pre>';

      // replace markdwon with generated html code block
      var first = text.substring(0, match.index) + '\n\n';
      var last = '\n\n' + text.substr(match.index + match[0].length);
      text = first + codeblock + last;

      // replace codeblock with placeholder until postConversion step
      text = this.hashBlock(text, codeblock);
    }

    return text;
  };

  Markdown.Extra.prototype.all = function(text) {
    text = this.tables(text);
    text = this.fencedCodeBlocks(text);
    return text;
  };

})();

