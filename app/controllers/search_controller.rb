class SearchController < ApplicationController

  def index  
    query =  params[:query] 
    @query = query
    logger.info "  Search query: #{query}"

    # remove puntuation and plurals.
    query = query.downcase.gsub(/[^\w]/, ' ').gsub(/ . /, ' ')
    logger.info "  Query no-punct: #{query}"

    query = Article.remove_stop_words query
    logger.info "  Removed stop words: #{query}"

    @query_corrected = Article.spell_check query
    logger.info "  Spell check: #{@query}"

    @results = Article.search_tank( @query_corrected, 
                              :fetch => [:title, :timestamp, :preview],
                              :snippets => [:content] )

    logger.info "  Results found: #{@results.size}"

    # Log the search results
    if Rails.env === 'production'
      logger.debug( "search-request: IP:#{request.env['REMOTE_ADDR']}, QUERY:#{@query}, QUERY_CORRECTED:#{@query_corrected}, FIRST_RESULT:#{@results.first.title}, RESULTS_N:#{@results.size}" )
    end

  end
  
end
