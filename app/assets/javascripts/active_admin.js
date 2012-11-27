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
	
	setInterval(function(){
		var arrows = $(".guidearrow");
		if(arrows.length){
			for(var a=0;a<arrows.length;a++){
				$(arrows[a]).css({ "display": "inline" });
			}
		}
	}, 250);
	
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