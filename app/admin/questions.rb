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

  form do |f|   # create/edit user form
    f.inputs "Question Details" do
      f.input :question
      f.input :context
      f.input :email
      f.input :name
      f.input :location
      f.input :status
    end
    f.buttons
  end
end