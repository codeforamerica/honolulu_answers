
class SearchController < ApplicationController


  def index

    client = IndexTank::Client.new(ENV['SEARCHIFY_API_URL'] || '<API_URL>')
    index = client.indexes("hnlanswers-"+ENV['RAILS_ENV'])

    @results = index.search(params[:q],
                            :fetch => 'title,timestamp', 
                            :snippet => 'text')
    
    if(params[:format] == "json") then
      # @results = Article.search(params[:q])
      render :json => {"results"=>@results}
    end

  end
  
end
