// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


var hnlAnswers = function (){
    
    
};


$(function(){
    $("#searchForm:not(.noanimation)").submit(function(e){       
        e.preventDefault();
        searchControl.startSearch($("#search").val());
        var query = $("#search").val();
        history.pushState({"query":query}, "Searching for - "+query, "/search?q="+encodeURIComponent(query));
    })
    window.onpopstate = function(event){
        console.log("popstate", event, window.location);
        if(window.location.pathname == "/"){
            // we are home.
            searchControl.transfromToHome();   
        }else if(window.location.pathname == "/search"){
            var params = window.location.search.replace("?", "").split("&")
            var query = null;
            for(p in params){
                if((params[p].split("=").length >1) && (params[p].split("=")[0] == "q")){
                    query = params[p].split("=")[1]
                }
            }
            console.log("query", query);
            if(query)
                searchControl.startSearch(query);
        }
    }

/*    $("#search").typeahead({items:6,
                            lookup: function(event){
                                var that = this
                                , items
                                , q
                                
                                this.query = this.$element.val()
                                
                                if (!this.query) {
                                    return this.shown ? this.hide() : this
                                }
                                
                                $.ajax("/autocomplete.json", {data:{q:this.query}, success:function(data){
                                    items = [];
                                    for( r in data.results){
                                        items.push(data.results[r].title);
                                    }


                                    if (!items.length) {
                                        return that.shown ? that.hide() : that
                                    }
                                    that.render(items).show()
                                }}, "json");
                                
                            }
                            
                           });*/

});






var searchController = function(){

    var self = this;
    this.startSearch = function(query){
        
        $.ajax("/search.json", {data:{q:query}, success:function(data){
            $("#results ul").empty();
            for(r in data.results){
                console.log("result: ", data.results[r]);
                self.addResult(data.results[r]);
            }
            $("#searchstatus").find("strong").text(query);
            $("#searchstatus").find("div.count").text(data.matches+" result"+
                                                      (data.matches.length > 1 ? "s":"")
                                                      +" found");


        }});
        self.transfromToResults();
    };

    this.transfromToResults = function(){
        $("#searchstatus").fadeIn();
        $("#results ul").fadeIn();
        $("#mainContainer").fadeIn("fast");
        $("#mainContainer").animate({"margin-top":"0px"});
        $("#bgTopDiv").animate({height:"87px",
                                "margin-top":"0px",
                                "padding":"0px",
                                "background-position":"0px -200px"});
        $("#browse").fadeOut('fast');
        $("#searchContent p.display").fadeOut('fast');
        $("#searchContent p.hnlanswers").fadeIn('fast');
        $("#searchContent span").fadeOut('fast');
        $("#searchContent form").animate({"width":"50%", "padding-top":"40px", "padding-bottom":"10px"}, 200);
        $("#searchContent").css("text-align", "right");
        $("#searchContent form").css("margin", "auto");
        $("#searchContent").css("background-color", "rgba(255, 198, 10, 0.2);");
        $("#searchContent").animate({width:"100%",
                                     padding: "0px",
                                     "margin-top":"0px"}, 200);

    };

    this.transfromToHome = function(){
        $("#searchstatus").fadeOut();
        $("#results ul").fadeOut();
        $("#mainContainer").fadeOut("fast");
        $("#mainContainer").animate({"margin":"120px auto"});
        $("#bgTopDiv").css("height", "");
        $("#bgTopDiv").animate({"padding":"50px 0px 100px 0px",
                                "background-position":"0px 0px"});
        $("#browse").fadeIn('fast');
        $("#searchContent p.display").fadeIn('fast');
        $("#searchContent p.hnlanswers").fadeOut('fast');
        $("#searchContent span").fadeIn('fast');
        $("#searchContent form").animate({"width":"100%","margin":"0", "padding-top":"0px", "padding-bottom":"0px"}, 200);
        $("#searchContent").css("text-align", "left");
        $("#searchContent").css("background-color", "rgba(255, 198, 10, 0.8);");
        $("#searchContent").animate({width:"50%",
                                     padding: "25px",
                                     "margin":"70px auto"}, 200);

    };

    this.addResult = function(result){
        $("#results ul").append(Mustache.render(self.resultTemplate, result).replace(/\n/g, "<br />"));
    };
    this.resultTemplate = "<li><h1><a href='/articles/{{docid}}'>{{title}}</a></h1>"+
        "<div class='preview'>{{preview}}</div>" +
        "</li>";

};


window.searchControl = new searchController();