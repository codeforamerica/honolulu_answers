class SearchController < ApplicationController

  def index    
    query = params[:q].downcase

    ## Pre-process the search query for natural language searches

    # Remove common English words from the query
    eng_stop_list = CSV.read( "#{Rails.root.to_s}/lib/assets/eng_stop.csv" )
    query = (query.split - eng_stop_list.flatten).join " "

    logger.info "  Search string: '#{query}'"

    ## spell check the search query
    dict = Hunspell.new( "#{Rails.root.to_s}/lib/assets/dict/custom", 'custom' )
    query_corrected = []
    query.split.each do |term|
      if dict.check?( term ) == true
        query_corrected << term
      else 
        suggestion = dict.suggest( term ).first
        if suggestion.nil? # if no suggestion, stick with the existing term
          query_corrected << term
        else
          query_corrected << suggestion
        end
      end
    end
    query = query_corrected.join ' '

    logger.info "  Search string corrected: '#{query}'"


    @results = Article.search_tank( query, 
                              :fetch => [:title, :timestamp, :preview],
                              :snippets => [:text] )

    logger.info "  Results found: #{@results.size}"

    # Might be useful for fine-tuning search
    logger.debug( "#{request.env['REMOTE_ADDR']},#{params[:q]},#{@results.size}" )
    
    render :json => @results
  end
  
end
