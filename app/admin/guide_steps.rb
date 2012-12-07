ActiveAdmin.register GuideStep do
  controller.authorize_resource

  # Add to :parent Dropdown menu
  menu :parent => "Articles"
  # menu :priority => 4

  # View 
  index do
    #column :id
    column "Title", :title do |guide_step|
      link_to guide_step.title, [:admin, guide_step]
    end
    column :content
    column :step
    column "Updated", :updated_at
    default_actions # Add show, edit, delete column
  end

  form :partial => "form"

  show do |step|
      attributes_table do
        row :title
        row :content
        row :preview
        row :guide
        row :step
        row :updated_at
        row :created_at
      end
      active_admin_comments
    end
end