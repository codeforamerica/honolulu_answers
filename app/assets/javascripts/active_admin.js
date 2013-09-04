//= require active_admin/base
//= require jquery
//= require ./pagedown/Markdown.Converter.js
//= require ./pagedown/Markdown.Editor.js
//= require ./pagedown/Markdown.Sanitizer.js
//= require ./Markdown.Extra.js

$(document).ready(function(){

  // Prevent people from visiting the articles page
  $("a[href $= '/admin/articles']").addClass('articles_link');
  $(".articles_link").attr("href","#").click(function(e){
    e.preventDefaults();
  });

});
