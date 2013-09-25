ActiveAdmin.register Guide do

  menu :parent => "Articles"

  # Filterable attributes
  filter :title
  filter :tags
  filter :contact_id

  member_action :update, :method => :put do
    article = Guide.find(params[:id])
    authorize! :update, article
    article_attrs = params[:guide]

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
    column "Guide Title", :title do |guide|
      link_to guide.title, [:admin, guide]
    end
    column :category
    column :contact
    column "Created", :created_at
    column "Author", :user do |article|
      if(article.user.try(:department))
        (article.user.try(:email) || "") + ", " + (article.user.try(:department).name || "")        
      else
        (article.user.try(:email) || "")
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

  show do |guide|
    attributes_table do
      row :title
      row :content
      row :preview
      row :category
      row :contact
      row :slug
      row :created_at
      row :updated_at
      row :published
      row :pending_review
      table_for guide.guide_steps do
        column "Guide Steps" do |step|
          link_to step.step.to_s << ". " << step.title, admin_guide_step_path(step)
        end
      end
    end
  end
end
