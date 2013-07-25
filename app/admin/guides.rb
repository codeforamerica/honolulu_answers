ActiveAdmin.register Guide do
  # as per https://github.com/gregbell/active_admin/wiki/Enforce-CanCan-constraints
  controller do
    load_and_authorize_resource :except => :index
      def scoped_collection
        end_of_association_chain.accessible_by(current_ability)
      end
   end

  # Add to :parent Dropdown menu
  menu :parent => "Articles"
  # menu :priority => 3
  # Initialize tinymce
  # tinymce_assets
  # tinymce

  # Filterable attributes
  filter :title
  filter :tags
  filter :contact_id
  filter :status
  filter :is_published

  scope :all, :default => true do |articles|
    articles.includes [:category, :feedback]
  end

  # View
  index do
    #column :id
    column "Guide Title", :title do |guide|
      link_to guide.title, [:admin, guide]
    end
    column :category, :sortable => 'categories.name'
    column :contact
    column "Created", :created_at
    column "Author", :user do |article|
      if(article.user.try(:department))
        (article.user.try(:email) || "") + ", " + (article.user.try(:department).name || "")        
      else
        (article.user.try(:email) || "")
      end
    end
    # column :tags
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
