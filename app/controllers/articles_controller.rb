class ArticlesController < ApplicationController
  # redirect to the new paths (such as /quick_answers/1 instead of /articles/1)
  def show
    return render(:template => 'articles/missing') unless Article.exists? params[:id]
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
