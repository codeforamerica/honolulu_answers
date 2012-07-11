class SearchController < ApplicationController
   include RailsNlp::BigHugeThesaurus

  def index  
    query =  params[:q] 
    # return redirect_to articles_path if params[:query].nil?
    @query = query

    # remove puntuation and plurals.
    query = query.downcase.gsub(/[^\w]/, ' ').gsub(/ . /, ' ')

    # remove stop words
    query = Article.remove_stop_words query

    # expand the query
    stems,metaphones,synonyms = [[],[],[]]
    query.split.each do |term|
      stems << Text::PorterStemming.stem(term)
      synonyms << RailsNlp::BigHugeThesaurus.synonyms(term) 
      metaphones << Text::Metaphone.double_metaphone(term)
    end

    query_final =      "#{'title:'      + query.split.join('^10 title:')  + '^10'}"
    query_final << " OR #{'content:'    + query.split.join('^5 content:') + '^5'}"
    query_final << " OR #{'tags:'       + query.split.join('^8 tags:')    + '^8'}"
    query_final << " OR #{'stems:'      + stems.flatten.join(' OR stems:')}"
    query_final << " OR #{'metaphones:' + metaphones.flatten.compact.join(' OR metaphones:')}"
    query_final << " OR #{'synonyms:"'  + synonyms.flatten.first(3).join( '" OR synonyms:"') + '"'}"

    @results = Article.search_tank( query_final, 
                              :fetch => [:title, :timestamp, :preview],
                              :snippets => [:content] )
    # spell check the query
    @query_corrected = Article.spell_check query

    # Log the search results
    logger.debug( "search-request: IP:#{request.env['REMOTE_ADDR']}, params[:query]:#{query}, QUERY:#{query_final}, FIRST_RESULT:#{@results.first.title unless @results.empty?}, RESULTS_N:#{@results.size}" )

    respond_to do |format|
      format.json { render :json => @results }
      format.html #index.html.erb
    end
  end
  
end
