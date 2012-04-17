

class SearchController < ApplicationController


  def index
    if(params[:format] == "json") then
      @results = Article.search(params[:q])
      render :json => {"results"=>@results}
    end

  end
  
end
