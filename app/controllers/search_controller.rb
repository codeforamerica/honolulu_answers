class SearchController < ApplicationController

  def index
    client = IndexTank::Client.new(ENV['SEARCHIFY_API_URL'])
    index = client.indexes("hnlanswers-" + Rails.env)
    
    query = params[:q].downcase
    ## Pre-process the search query for natural language searches

    # Stop list of common English words
    eng_stop_list = CSV.read( "#{Rails.root.to_s}/lib/assets/eng_stop.csv" )

    # Remove these words from the query
    query = query.split - eng_stop_list.flatten
    query = query.join " "

    logger.info "  Search string: '#{query}'"

    # As this is just about the display of the text, it should be in the view after the search has taken place.
    if(query.include?(' '))
      query = "\"#{query}\""
    end
    
    @results = index.search("(#{query}) OR (title:#{query}) OR (tags:#{query})",
                            :fetch => 'title,timestamp,preview', 
                            :snippet => 'text')
    logger.info "  Results found: #{@results['results'].size}"

    # Try to spell check the query if no results were found
    if @results.first[1] == 0
      dict = Hunspell.new( "#{Rails.root.to_s}/lib/assets/en_US", 'en_US' )
      query_corrected = []

      query.split.each do |term|
        if dict.check?( term ) == false
          suggestion = dict.suggest( term ).first
          if suggestion.nil? # if no suggestion, stick with the existing term
            query_corrected << term
          else
            query_corrected << suggestion
          end
        else 
          query_corrected << term
        end
      end
      query = query_corrected.join ' '

      logger.info "  Corrected search string: '#{query}'"

      @results = index.search("(#{query}) OR (title:#{query}) OR (tags:#{query})",
                              :fetch => 'title,timestamp,preview', 
                              :snippet => 'text')

      logger.info "  Results found: #{@results['results'].size}"
    end

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
