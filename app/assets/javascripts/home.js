// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


var hnlAnswers = function (){
    
    
};


$(function(){
    $("#search_form").submit(function(e){       
        e.preventDefault();
        searchControl.startSearch($("#search").val());
        

    });
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
        
            $("#results").fadeIn();
        }});

        $("#search_content p").fadeOut('fast');
        $("#search_content h1").fadeOut('fast');
        $("#search_content form").animate({"margin":"5"}, 300);
        $("#search_content").animate({padding: "10",
                                      "margin-top":"20"}, 300);

    };
    this.addResult = function(result){
        $("#results ul").append(Mustache.render(self.resultTemplate, result));
    };
    this.resultTemplate = "<li><div class='title'><a href='/articles/{{id}}'>{{title}}</a></div><div>{{content}}</div></li>";

};


window.searchControl = new searchController();