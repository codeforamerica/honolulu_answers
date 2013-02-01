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

	/* if( $("#page_title").text() == "Dashboard"){
		var headers = $("thead th");
		for(var h=0;h<headers.length;h++){
			if( $($("thead th")[h]).text() == "Author" ){
				$($("thead th")[h]).text("Writer");
				break;
			}
		}
	}

	if( $("#page_title").text() == "Quick Answers"){
		var headers = $("thead th");
		for(var h=0;h<headers.length;h++){
			if( $($("thead th")[h]).text() == "Writer link" ){
				$($("thead th")[h]).text("Write-a-thon Author Link");
				break;
			}
		}
	}

	if( $("#page_title").text() == "Web Services"){
		var headers = $("thead th");
		for(var h=0;h<headers.length;h++){
			if( $($("thead th")[h]).text() == "Writer link" ){
				$($("thead th")[h]).text("Write-a-thon Author Link");
				break;
			}
		}
	}

	if( $("#page_title").text() == "Guides"){
		var headers = $("thead th");
		for(var h=0;h<headers.length;h++){
			if( $($("thead th")[h]).text() == "Writer link" ){
				$($("thead th")[h]).text("Write-a-thon Author Link");
				break;
			}
		}
	} */
});
