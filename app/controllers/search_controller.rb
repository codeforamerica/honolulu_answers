class SearchController < ApplicationController
   include RailsNlp::BigHugeThesaurus

  def index  
    query =  params[:q] 
    return redirect_to articles_path if params[:q].empty? 
    @query = query

    # remove puntuation and plurals.
    query = query.downcase.gsub(/[^\w]/, ' ').gsub(/ . /, ' ')

    # remove stop words
    query = Article.remove_stop_words query

    # spell check the query
    @query_corrected = Article.spell_check query
    @is_corrected = @query_corrected !=  query

    # expand the query
    query_final = Article.expand_query( query )

    # perform the search
    @results = Article.search_tank( query_final, :conditions => { :is_published => true } )

    # Log the search results
    puts "search-request: IP:#{request.env['REMOTE_ADDR']}, params[:query]:#{query}, QUERY:#{query_final}, FIRST_RESULT:#{@results.first.title unless @results.empty?}, RESULTS_N:#{@results.size}" 

    respond_to do |format|
      format.json { render :json => @results }
      format.html #index.html.erb
    end
  end
  
end
