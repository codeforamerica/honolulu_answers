class SearchController < ApplicationController

  def index  
    query =  params[:query] 
    @query = query
    logger.info "  Search query: #{query}"

    query = query.downcase.gsub(/[^\w]/, ' ').gsub(/ . /, ' ')
    logger.info "  Query cleaned: #{query}"

    query = Article.remove_stop_words query
    logger.info "  Removed stop words: #{query}"

    @query_corrected = Article.spell_check query
    logger.info "  Spell check: #{@query}"

    @results = Article.search_tank( @query_corrected, 
                              :fetch => [:title, :timestamp, :preview],
                              :snippets => [:content] )

    logger.info "  Results found: #{@results.size}"

    # Might be useful for fine-tuning search
    logger.debug( "#{request.env['REMOTE_ADDR']},#{@query},#{@results.size}" )

  end
  
end
