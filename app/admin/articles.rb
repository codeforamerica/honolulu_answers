ActiveAdmin.register Article do

  # Filterable attributes
  filter :title
  filter :tags
  filter :contact_id

  # override controller actions
  member_action :update, :method => :put do
    article = Article.find(params[:id])
    authorize! :update, article
    article_attrs = params[:article]

    if params[:publish]
      authorize! :publish, article
      article_attrs.merge! :published => true
    elsif params[:unpublish]
      authorize! :publish, article
      article_attrs.merge! :published => false
    end

    if params[:ask_review]
      article_attrs.merge! :pending_review => true
    elsif params[:ask_revise]
      article_attrs.merge! :pending_review => false
    end

    if article.update_attributes(article_attrs)
      flash[:notice] = "Article successfully updated"
    else
      flash[:error] = "There was a problem saving the article"
    end

    redirect_to({ :action => :index })
  end

  # View
  index do
    column "Article Title", :title do |article|
      link_to article.title, admin_article_path(article)
    end
    column :category
    column :contact
    column "Created", :created_at
    column "Author", :user do |article|
      if article.user.try(:department)
        (article.user.try(:email) || "") + ", " + (article.user.try(:department).name || "")
      else
        article.user.try(:email) || ""
      end
    end
    column :slug
    column :published
    column :pending_review
    actions :defaults => true do |article|
      show_on_site_text = article.published? ? "Open" : "Preview"
      link_to show_on_site_text, article_path(article)
    end
  end

  form :partial => "shared/admin/article_form"
end
