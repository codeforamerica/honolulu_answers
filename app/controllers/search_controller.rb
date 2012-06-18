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

    logger.info "  Corrected search string: '#{query}'"

    # What is this for?  --PH
    if(query.include?(' '))
      query = "\"#{query}\""
    end
    
    @results = index.search("(#{query}) OR (title:#{query}) OR (tags:#{query})",
                            :fetch => 'title,timestamp,preview', 
                            :snippet => 'text')

    logger.info "  Results found: #{@results['results'].size}"

    # # Try to spell check the query if no results were found
    # if temp_results.first[1] == 0
    #   dict = Hunspell.new( "#{Rails.root.to_s}/lib/assets/dict/custom", 'custom' )
    #   query_corrected = []

    #   query.split.each do |term|
    #     if dict.check?( term ) == false
    #       suggestion = dict.suggest( term ).first
    #       if suggestion.nil? # if no suggestion, stick with the existing term
    #         query_corrected << term
    #       else
    #         query_corrected << suggestion
    #       end
    #     else 
    #       query_corrected << term
    #     end
    #   end
    #   query = query_corrected.join ' '
    #   # remove the stop words again, in case one of the mistyped words is somethign like 'get'
    #   query = (query.split - eng_stop_list.flatten).join " "

    #   logger.info "  Corrected search string: '#{query}'"

    #   temp_results = index.search("(#{query}) OR (title:#{query}) OR (tags:#{query})",
    #                           :fetch => 'title,timestamp,preview', 
    #                           :snippet => 'text')

    #   logger.info "  Results found: #{temp_results['results'].size}"
    # end
    
    # @results = temp_results

    render :json => @results

  end

  def autocomplete
    client = IndexTank::Client.new(ENV['SEARCHIFY_API_URL'] || '<API_URL>')
    index = client.indexes("hnlanswers-"+ENV['RAILS_ENV'])

    
    if(params[:format] == "json") then
      # @results = Article.search_titles(params[:q])
      @results = index.search("("+params[:q]+") OR (title:"+params[:q]+ ") OR (tags:"+params[:q]+")",
                              :fetch => 'title', 
                              :snippet => 'text')
      render :json => { :results =>@results }
    end
  end
  
end
