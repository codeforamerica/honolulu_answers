ActiveAdmin.register Contact do
  # This will authorize the Foobar class
  # The authorization is done using the AdminAbility class
  controller.authorize_resource  


   # View 
  index do
    column :id
    column "Name", :name do |contact|
      link_to contact.name, [:admin, contact]
    end
    #column :department
    column :url
    column "Created", :created_at
    # column :tags
    default_actions # Add show, edit, delete column
  end

  form do |f|
    f.inputs "Contact Details" do
      f.input :name
      f.input :subname, :label => "Email address"
      f.input :number, :label => "Phone number"
      f.input :url
      f.input :address
      f.input :department, :label => "Address 2"
      f.input :description
    end
    f.buttons
  end

end
