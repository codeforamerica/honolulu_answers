//= require active_admin/base
//= require jquery
//= require ./pagedown/Markdown.Converter.js
//= require ./pagedown/Markdown.Editor.js
//= require ./pagedown/Markdown.Sanitizer.js
//= require ./Markdown.Extra.js

$(document).ready(function(){
  // Clicking Articles link on dashboard > open up context menu
  $("a[href $= '/admin/articles']").attr("href","#");
  $("a[href $= '#']").click(function(e){
    $("a[href $= '#']").next().css({ "display": "block" });
  });

  var arrows = $(".guidearrow");
  if(arrows.length){
    setInterval(function(){
      for(var a=0;a<arrows.length;a++){
        $(arrows[a]).css({ "display": "inline" });
      }
    }, 250);
  }
});
