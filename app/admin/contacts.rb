ActiveAdmin.register Contact do
  # This will authorize the Foobar class
  # The authorization is done using the AdminAbility class
  controller.authorize_resource  


   # View 
  index do
    #column :id
    column "Name", :name
    column :department
    column :url
    column "Created", :created_at
    # column :tags
    default_actions # Add show, edit, delete column
  end
end