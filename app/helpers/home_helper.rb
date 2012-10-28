module HomeHelper
  def popular_articles
    Article.joins(:feedback).limit(5).order('yes_count DESC')
  end
end
