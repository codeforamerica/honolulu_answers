module ArticlesHelper
  def article_list_tag(article_id, description)
    content_tag(:li, link_to(description, article_path(article_id)))
  end
end
