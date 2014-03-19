// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function(){
    $(".suggestion").ready(function() {
        //$(".suggestion a").text("djibouti");
        var sugg = $(".suggestion a").text();
        $.ajax("/search.json", {data:{q:sugg}, success:function(data){
            if(data.length==0){
                $(".suggestion").hide();
            }
        }});
    });

    if($(window).width()<=600)
        searchControl.clearTransforms();

    $(window).resize(function(){

        if($(window).width()<=600){
            if(window.location.pathname != "/")
                $("#navigation").addClass("mobileresults");
            searchControl.clearTransforms();
        }else{
            $("#navigation").removeClass("mobileresults");
        }
    });
});
