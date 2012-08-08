class SearchController < ApplicationController
  def index
    query =  params[:q].strip 
    return redirect_to root_path if (params[:q].nil? || params[:q].empty?) 
    @query = query

    # remove puntuation and plurals.
    query = query.downcase.gsub(/[^\w]/, ' ').gsub(/ . /, ' ')

    # remove stop words
    query = Article.remove_stop_words query

    # Searchify can't handle requests longer than this (because of query expansion + Tanker inefficencies.  >10 can result in >8000 byte request strings)
    if query.split.size > 10
      @query_corrected = query
      respond_to do |format|
        format.json { render :json => [] }
        format.html 
      end and return
    end
    # spell check the query.  if no correction has taken place, this is nil.
    @query_corrected = Article.spell_check query
    
    if query.length > 0
      # expand the query
      query_final = Article.expand_query( query )
      
      # perform the search
      @results = Article.search_tank( query_final, :conditions => { :is_published => true } )

      # Log the search results
      puts "search-request: IP:#{request.env['REMOTE_ADDR']}, params[:query]:#{query}, QUERY:#{query_final}, FIRST_RESULT:#{@results.first.title unless @results.empty?}, RESULTS_N:#{@results.size}" 

    else
      @results = []
    end

    respond_to do |format|
      format.json { render :json => @results }
      format.html #index.html.erb
    end
  end
  
end
