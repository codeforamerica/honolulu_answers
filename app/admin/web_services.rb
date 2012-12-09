ActiveAdmin.register WebService do
	# This will authorize the Foobar class
  # The authorization is done using the AdminAbility class
  controller.authorize_resource
  
  # Add to :parent Dropdown menu
  menu :parent => "Articles"
  # menu :priority => 5
  
  # Filterable attributes
  filter :title
  filter :tags
  filter :contact_id
  filter :status

  
  # View 
  index do
    #column :id
    column "Web Service Title", :title do |article|
      link_to article.title, [:admin, article]
    end
    column :category
    column :contact
    column "Created", :created_at
    column "Writer", :author_name
    # column :tags
    column :slug
    column "Status", :status
    default_actions # Add show, edit, delete column
  end
  
    form :partial => "form"


end
