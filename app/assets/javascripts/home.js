// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


var hnlAnswers = function (){
    
    
};


$(function(){
    /*
    $("form#search:not(.noanimation)").submit(function(e){       
        e.preventDefault();
        var query = $("#query").val().replace(/\"/g,"");
        if(query == '') { return; }
        searchControl.startSearch(query);
        history.pushState({"query":query}, "Searching for - "+query, "/search?q="+encodeURIComponent(query));
    })
    window.onpopstate = function(event){
        if(window.location.pathname == "/"){
            // we are home.
            searchControl.clearTransforms();   
        }else if(window.location.pathname == "/search"){
            var params = window.location.search.replace("?", "").split("&");
            var query = null;
            for(p in params){
                if((params[p].split("=").length >1) && (params[p].split("=")[0] == "q")){
                    query = params[p].split("=")[1].replace(/\+/g," ").replace(/\"/g,"").replace(/%22/g,"");
                }
            }
            if(query)
                searchControl.startSearch(decodeURIComponent(query));
        }
    }
*/

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

/*

var searchController = function(){
    var self = this;
    this.startSearch = function(query){
        $("#searchStatus").hide();
        $("#loading").show();
        $.ajax("/search.json", {data:{q:query}, success:function(data){
            $("#results ul").empty();
            for(i=0; i < data.length;i++){
                self.addResult(data[i]);
            }
            $("#loading").hide();
            $("#searchStatus").find("strong").text(query.replace("+"," "));
            $("#searchStatus").find("div.count").text(data.length+" result"+
                                                      (data.length != 1 ? "s":"")
                                                      +" found");
            $("#searchStatus").fadeIn('fast');
            if($(window).width() <= 600)
                $(window).scrollTop(80);
        }});
        self.transfromToResults();
    };

    this.clearTransforms = function(){
        $("body").removeClass("results");
    }

    this.transfromToResults = function(){
        $("body").addClass("results");
        $("#content").toggleClass("active");
   };

    this.addResult = function(result){
        $("#results ul").append(Mustache.render(self.resultTemplate, result).replace(/\n/g, "<br />"));
    };
    this.resultTemplate = "<li><h1><a href='/articles/{{slug}}'>{{title}}</a></h1>"+
        "<div class='preview'>{{preview}}</div>" +
        "</li>";
};

window.searchControl = new searchController();
*/