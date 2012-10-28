ActiveAdmin.register Question do
  controller.authorize_resource

  index do
    column :id
    column :question
    column :email
    column :name
    column :location
    column :status
    column "Created", :created_at
    default_actions # Add show, edit, delete column
  end
end