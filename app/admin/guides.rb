ActiveAdmin.register Guide do
  # as per https://github.com/gregbell/active_admin/wiki/Enforce-CanCan-constraints
  controller do
    load_and_authorize_resource :except => :index
    def scoped_collection
      end_of_association_chain.accessible_by(current_ability)
    end
   end

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
    default_actions # Add show, edit, delete column
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
