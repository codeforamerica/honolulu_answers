ActiveAdmin.register Guide do

  menu :parent => "Articles"

  # Filterable attributes
  filter :title
  filter :tags
  filter :contact_id
  filter :status

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
    column "Status", :status
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
      row :status
      table_for guide.guide_steps do
        column "Guide Steps" do |step|
          link_to step.step.to_s << ". " << step.title, admin_guide_step_path(step)
        end
      end
    end
  end
end
