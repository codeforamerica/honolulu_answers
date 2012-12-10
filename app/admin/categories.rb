ActiveAdmin.register Category do
  # This will authorize the Foobar class
  # The authorization is done using the AdminAbility class
  controller.authorize_resource

  # View
  index do
    #column :id
    column :name, :sortable => :name
    column "Created", :created_at
    column "Updated", :updated_at
    column "Description", :description
    #column "Slug", :slug
    default_actions # Add show, edit, delete column
  end
end