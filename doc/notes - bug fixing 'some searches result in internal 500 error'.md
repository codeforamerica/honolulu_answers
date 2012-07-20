## Some searches crash with 'Sorry but something went wrong'

**Notes on bug report**

### Examples

www.hnlanswers.herokuapp.com/search.json?q=driver+license+camping+human+sick+salary+compensation

* Works with no query prerocessing

-------------------

title:driver^10 title:license^10 title:camping^10 title:human^10 title:sick^10 title:salary^10 title:compensation^10

OR

content:driver^5 content:license^5 content:camping^5 content:human^5 content:sick^5 content:salary^5 content:compensation^5

OR

tags:driver^8 tags:license^8 tags:camping^8 tags:human^8 tags:sick^8 tags:salary^8 tags:compensation^8

OR

stems:driver^3 stems:licens^3 stems:camp^3 stems:human^3 stems:sick^3 stems:salari^3 stems:compens^3

OR

metaphones:TRFR^2 metaphones:LSNS^2 metaphones:KMPN^2 metaphones:HMN^2 metaphones:SK^2 metaphones:SLR^2 metaphones:KMPN^2

OR

synonyms:driver synonyms:license synonyms:camping synonyms:human synonyms:sick synonyms:salary synonyms:compensation


--------------------

Error message is:

    Net::HTTPBadResponse: wrong status line: "<html>"
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/1.9.1/net/http.rb:2564:in `read_status_line'
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/1.9.1/net/http.rb:2551:in `read_new'
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/1.9.1/net/http.rb:1319:in `block in transport_request'
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/1.9.1/net/http.rb:1316:in `catch'
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/1.9.1/net/http.rb:1316:in `transport_request'
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/1.9.1/net/http.rb:1293:in `request'
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/gems/1.9.1/gems/rest-client-1.6.7/lib/restclient/net_http_ext.rb:51:in `request'
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/gems/1.9.1/gems/newrelic_rpm-3.4.0/lib/new_relic/agent/instrumentation/net.rb:22:in `block in request_with_newrelic_trace'
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/gems/1.9.1/gems/newrelic_rpm-3.4.0/lib/new_relic/agent/method_tracer.rb:242:in `trace_execution_scoped'
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/gems/1.9.1/gems/newrelic_rpm-3.4.0/lib/new_relic/agent/instrumentation/net.rb:21:in `request_with_newrelic_trace'
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/gems/1.9.1/gems/tanker-1.1.6/lib/indextank_client.rb:48:in `block in execute'
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/1.9.1/net/http.rb:745:in `start'
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/gems/1.9.1/gems/tanker-1.1.6/lib/indextank_client.rb:48:in `execute'
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/gems/1.9.1/gems/tanker-1.1.6/lib/indextank_client.rb:15:in `GET'
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/gems/1.9.1/gems/tanker-1.1.6/lib/indextank_client.rb:183:in `search'
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/gems/1.9.1/gems/tanker-1.1.6/lib/tanker.rb:113:in `search_results'
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/gems/1.9.1/gems/tanker-1.1.6/lib/tanker.rb:139:in `search'
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/gems/1.9.1/gems/tanker-1.1.6/lib/tanker.rb:279:in `search_tank'
      from (irb):4
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/gems/1.9.1/gems/railties-3.2.6/lib/rails/commands/console.rb:47:in `start'
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/gems/1.9.1/gems/railties-3.2.6/lib/rails/commands/console.rb:8:in `start'
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/gems/1.9.1/gems/railties-3.2.6/lib/rails/commands.rb:41:in `<top (required)>'
      from script/rails:6:in `require'
      from script/rails:6:in `<main>'

-------------------

Removing new relic does not help.  New error message:

    irb(main):001:0> Article.search_tank(Article.expand_query('driver license camping human sick salary compensation'))
      Keyword Load (1.0ms)  SELECT "keywords".* FROM "keywords" WHERE "keywords"."name" = 'driver' LIMIT 1
      Keyword Load (0.2ms)  SELECT "keywords".* FROM "keywords" WHERE "keywords"."name" = 'license' LIMIT 1
      Keyword Load (0.3ms)  SELECT "keywords".* FROM "keywords" WHERE "keywords"."name" = 'camping' LIMIT 1
      Keyword Load (0.3ms)  SELECT "keywords".* FROM "keywords" WHERE "keywords"."name" = 'human' LIMIT 1
      Keyword Load (0.5ms)  SELECT "keywords".* FROM "keywords" WHERE "keywords"."name" = 'sick' LIMIT 1
      Keyword Load (0.4ms)  SELECT "keywords".* FROM "keywords" WHERE "keywords"."name" = 'salary' LIMIT 1
      Keyword Load (0.4ms)  SELECT "keywords".* FROM "keywords" WHERE "keywords"."name" = 'compensation' LIMIT 1
    Net::HTTPBadResponse: wrong status line: "<html>"
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/1.9.1/net/http.rb:2564:in `read_status_line'
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/1.9.1/net/http.rb:2551:in `read_new'
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/1.9.1/net/http.rb:1319:in `block in transport_request'
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/1.9.1/net/http.rb:1316:in `catch'
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/1.9.1/net/http.rb:1316:in `transport_request'
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/1.9.1/net/http.rb:1293:in `request'
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/gems/1.9.1/gems/rest-client-1.6.7/lib/restclient/net_http_ext.rb:51:in `request'
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/gems/1.9.1/gems/tanker-1.1.6/lib/indextank_client.rb:48:in `block in execute'
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/1.9.1/net/http.rb:745:in `start'
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/gems/1.9.1/gems/tanker-1.1.6/lib/indextank_client.rb:48:in `execute'
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/gems/1.9.1/gems/tanker-1.1.6/lib/indextank_client.rb:15:in `GET'
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/gems/1.9.1/gems/tanker-1.1.6/lib/indextank_client.rb:183:in `search'
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/gems/1.9.1/gems/tanker-1.1.6/lib/tanker.rb:113:in `search_results'
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/gems/1.9.1/gems/tanker-1.1.6/lib/tanker.rb:139:in `search'
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/gems/1.9.1/gems/tanker-1.1.6/lib/tanker.rb:279:in `search_tank'
      from (irb):1
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/gems/1.9.1/gems/railties-3.2.6/lib/rails/commands/console.rb:47:in `start'
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/gems/1.9.1/gems/railties-3.2.6/lib/rails/commands/console.rb:8:in `start'
      from /home/phil/.rbenv/versions/1.9.3-p194/lib/ruby/gems/1.9.1/gems/railties-3.2.6/lib/rails/commands.rb:41:in `<top (required)>'
      from script/rails:6:in `require'
      from script/rails:6:in `<main>'

  ----

  It seems to be related to the length of the search query.

  ### Failed search:
  *"<search query> => <size of query>"*

  "red orange yellow green blue black pink" => 666

  "blues " * 130 => 780

  "blues " * 129 => 774



  ### Working search:

  "red orange yellow green blue black" => 581

  "'blues '* 105" => 630

  "blues " * 120 => 720

  "blues " * 125 => 750

  "blues " * 128 => 768


  
  ---------

  SOLUTION FOUND

  This works:

  Article.search_tank ("blues "*150).first(769)

  This does not work:

  Article.search_tank ("blues "*150).first(770)