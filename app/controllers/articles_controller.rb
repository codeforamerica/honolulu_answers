class ArticlesController < ApplicationController

  # GET /articles
  # GET /articles.json
  def index
    @bodyclass = "results"

    @categories = Category.by_access_count

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @categories }
    end
  end

  # redirect to the new paths (such as /quick_answers/1 instead of /articles/1)
  def show
    return render(:template => 'articles/missing') unless Article.exists? params[:id]
    @article = Article.find(params[:id])
    return redirect_to @article, status: :moved_permanently
  end

  # This is what you would expect to be called CategoriesController#show
  def article_type
    @article_type = params[:content_type]
    # convert paramaterized url
    @article_type = @article_type.gsub(/-/, ' ').titlecase.gsub(/ /, '')

    @articles = Article.find_by_type(@article_type)
  end

end
