class SearchController < ApplicationController

  def index
    client = IndexTank::Client.new(ENV['SEARCHIFY_API_URL'])
    index = client.indexes("hnlanswers-"+ENV['RAILS_ENV'])
    

    @results = index.search("("+params[:q]+") OR (title:"+params[:q]+ ") OR (tags:"+params[:q]+")",
                            :fetch => 'title,timestamp,preview', 
                            :snippet => 'text')
    render :json => @results

  end

  def autocomplete
    client = IndexTank::Client.new(ENV['SEARCHIFY_API_URL'] || '<API_URL>')
    index = client.indexes("hnlanswers-"+ENV['RAILS_ENV'])

    
    if(params[:format] == "json") then
      # @results = Article.search_titles(params[:q])
      @results = index.search("title:"+params[:q], :fetch => 'title,timestamp')
      render :json => { :results =>@results }
    end
  end
  
end
