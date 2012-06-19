module ArticlesHelper
  
  def article_list_tag(article_id, description)
    content_tag(:li, link_to(description, article_path(article_id)))
  end
  
  def missing_article_list_tag(article_id, description)
    content_tag(:li, description, :class => "missing-article")
  end
  
end
