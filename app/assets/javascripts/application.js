// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require mustache
//= require bootstrap-typeahead
//= require indextank/jquery.indextank.ize.js
//= require indextank/jquery.indextank.autocomplete.js
//= require indextank/querybuilder.js
//= require indextank/jquery.indextank.ajaxsearch.js
//= require indextank/jquery.indextank.renderer.js
//= require indextank/jquery.indextank.instantsearch.js
//= require_tree .
//

$(document).ready(function(){
    // let the form be 'indextank-aware'
    $("#searchForm").indextank_Ize("http://8bpwv.api.searchify.com", "hnlanswers-production");
    // let the query box have autocomplete
    $("#search").indextank_Autocomplete().indextank_AjaxSearch( {listeners: renderer}).indextank_InstantSearch();
});
