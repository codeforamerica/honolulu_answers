
class SearchController < ApplicationController


  def index

    client = IndexTank::Client.new(ENV['SEARCHIFY_API_URL'] || '<API_URL>')
    index = client.indexes("hnlanswers-"+ENV['RAILS_ENV'])

    
    if(params[:format] == "json") then
      @results = index.search(params[:q],
                              :fetch => 'title,timestamp', 
                              :snippet => 'text')
      render :json => @results
    end

  end
  
end
