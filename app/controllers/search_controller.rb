class SearchController < ApplicationController

  def index    
    query = params[:q]
    ## Pre-process the search query for natural language searches

    # Stop list of common English words
    eng_stop_list = CSV.read( "#{Rails.root.to_s}/lib/assets/eng_stop.csv" )

    # Remove these words from the query
    query = (query.split - eng_stop_list.flatten).join " "

    logger.info "Search Query: #{query}"


    # TODO: Either manipulate @results to look like the old output, 
    #       or change how results are displayed
    # 
    # NOT WORKING
    @results = Article.search_tank( query, 
                              :fetch => [:title, :timestamp, :preview],
                              :snippets => [:text] )

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
