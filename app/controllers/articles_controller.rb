class ArticlesController < ApplicationController
  # GET /articles
  # GET /articles.json

  # caches_page :show # TODO: make the cache expire when an article is updated.  Currently can't get the cache to clear properly.

  def index
    @bodyclass = "results"
  
    @categories = Category.by_access_count
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @categories }
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    # redirect to the new paths (such as /quick_answers/1 instead of /articles/1)
    @article = Article.find(params[:id])
    return redirect_to @article, status: :moved_permanently
  end
  

  def article_type
    @article_type = params[:content_type]
    # convert paramaterized url
    @article_type = @article_type.gsub(/-/, ' ').titlecase.gsub(/ /, '')

    @articles = Article.find_by_type(@article_type)
  end

end
