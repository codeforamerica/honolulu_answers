class QuickAnswersController < ApplicationController

  before_filter :check_article_exists
  before_filter :find_article

  def preview
    authorize! :preview, @article
    flash.now[:info] = @article.published? ? "Up to date" : "Changes have been made"
    set_content_variables(@article)
    @article.legacy? ? render(:show_html) : render(:show)
  end

  def show
    @article = @article.latest_published
    authorize! :read, @article
    return if redirect_old_permalinks(@article)
    increment_access_counts @article
    set_content_variables(@article)
    flash[:info] = @article.status
    @article.legacy? ? render(:show_html) : render(:show)
  end

  private

  def check_article_exists()
    render(:template => 'articles/missing') unless Article.exists?(params[:id])
    return
  end

  def find_article
    @article = QuickAnswer.find(params[:id])
  end

  def redirect_old_permalinks(article)
    correct_path = "/quick_answers/" << article.slug
    flash[:info] = "Expected: #{correct_path}. Actual: #{request.path}"
    if request.path != correct_path
      redirect_to correct_path
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
