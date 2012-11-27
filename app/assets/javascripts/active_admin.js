//= require active_admin/base
//= require jquery
//= require markdown.converter
//= require markdown.sanitizer
//= require markdown.editor

$(document).ready(function(){
	// Clicking Articles link on dashboard > open up context menu
	$("a[href $= '/admin/articles']").attr("href","#");
	$("a[href $= '#']").click(function(e){
		$("a[href $= '#']").next().css({ "display": "block" });
	});
});