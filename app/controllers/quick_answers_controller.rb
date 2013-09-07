class QuickAnswersController < ApplicationController

  def preview
    return if check_article_exists(params[:id])
    @article = QuickAnswer.find(params[:id])
    authorize! :preview, @article
    flash.now[:info] = "This is a preview of the article"
    set_content_variables(@article)
    @article.legacy? ? render(:show_html) : render(:show)
  end

  def show
    return if check_article_exists(params[:id])
    @article = QuickAnswer.find(params[:id]).latest_published_version
    return if redirect_old_permalinks(@article)
    authorize! :read, @article
    increment_access_counts @article
    set_content_variables(@article)
    @article.legacy? ? render(:show_html) : render(:show)
  end

  private

  def check_article_exists(article_id)
    render(:template => 'articles/missing') unless Article.exists?(article_id)
  end

  def redirect_old_permalinks(article)
    if request.path != quick_answer_path(article)
      redirect_to article_path(article), :status => :moved_permanently
    end
  end

  def increment_access_counts(article)
    article.delay.increment! :access_count
    article.delay.category.increment!(:access_count) if article.category
  end

  def set_content_variables(article)
    if article.legacy?
      @content_html = article.content
    else
      @content_main = article.md_to_html(:content_main)
      @content_main_extra = article.md_to_html(:content_main_extra)
      @content_need_to_know = article.md_to_html(:content_need_to_know)
    end
  end
end
