// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


var hnlAnswers = function (){
    
    
};


$(function(){
    $("#searchForm").submit(function(e){       
        e.preventDefault();
        searchControl.startSearch($("#search").val());        
    })
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
                                                      (data.matches.length > 0? "s":"")
                                                      +" found");
            $("#searchstatus").fadeIn();
            $("#results ul").fadeIn();
        }});
        $("#bgTopDiv").animate({height:"87px",
                                "margin-top":"0px"});
        
        $("#bgTopDiv").css("background-position","0px -200px");
        $("#searchContent p").fadeOut('fast');
        $("#searchContent span").fadeOut('fast');
        $("#searchContent form").animate({"margin":"0", "padding-top":"40px", "padding-bottom":"10px"}, 300);
        $("#searchContent").css("text-align", "center");
        $("#searchContent").css("background-color", "rgba(255, 198, 10, 0.2);");
        $("#searchContent").animate({width:"100%",
                                     padding: "0px",
                                     "margin-top":"0px"}, 300);

    };
    this.addResult = function(result){
        $("#results ul").append(Mustache.render(self.resultTemplate, result).replace(/\n/g, "<br />"));
    };
    this.resultTemplate = "<li><h1><a href='/articles/{{docid}}'>{{title}}</a></h1>"+
        "<div>{{&snippet_text}}</div>" +
        "</li>";

};


window.searchControl = new searchController();