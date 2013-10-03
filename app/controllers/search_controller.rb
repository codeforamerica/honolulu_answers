class SearchController < ApplicationController
  def index
    return redirect_to root_path if params[:q].blank?
    query = params[:q].strip
    @query = query

    # spell check the query.
    @query_corrected = Article.spell_check query

    # remove puntuation and plurals.
    query = query.downcase.gsub(/[^\w]/, ' ').gsub(/ . /, ' ')

    # remove stop words
    query = Article.remove_stop_words query

    # Searchify can't handle requests longer than this (because of query
    # expansion + Tanker inefficencies.  >10 can result in >8000 byte request
    # strings)
    if query.split.size > 10 || query.blank?
      @query_corrected = query
      @results = []
      return
    end

    # expand the query
    query_final = Article.expand_query(query)

    # perform the search
    @results = Article.search(query_final).select(&:published?)

    # Log the search results
    puts "search-request: IP:#{request.env['REMOTE_ADDR']}, params[:query]:#{query}, QUERY:#{query_final}, FIRST_RESULT:#{@results.first.title unless @results.empty?}, RESULTS_N:#{@results.size}" 

    respond_to do |format|
      format.json  { render @results }
      format.html
    end
  end
end
