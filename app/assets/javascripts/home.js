// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


var hnlAnswers = function (){
    
    
};


$(function(){
    $("#search_form").submit(function(e){       
        e.preventDefault();
        searchControl.startSearch($("#search").val());        
    })
    $("#search").typeahead({items:6,
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
        $("#results ul").append(Mustache.render(self.resultTemplate, result).replace(/\n/g, "<br />"));
    };
    this.resultTemplate = "<li><div class='title'>"+
        "<a href='/articles/{{docid}}'>{{title}}</a></div>"+
        "<div>{{&snippet_text}}</div></li>";

};


window.searchControl = new searchController();