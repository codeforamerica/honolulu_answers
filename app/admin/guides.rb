ActiveAdmin.register Guide do
# This will authorize the Foobar class
  # The authorization is done using the AdminAbility class
  controller.authorize_resource
  
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
  
  # View 
  index do
    #column :id
    column "Guide Title", :title do |guide|
      link_to guide.title, [:admin, guide]
    end
    column :category
    column :contact
    column "Created", :created_at
    column "Author", :user do |article|
      article.user.try(:email)
    end
    # column :tags
    column :slug
    column "Status", :status
    default_actions # Add show, edit, delete column
  end
  
  form :partial => "form"


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
