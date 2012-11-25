ActiveAdmin.register QuickAnswer do
	# This will authorize the Foobar class
  # The authorization is done using the AdminAbility class
  # controller.authorize_resource
  
  # Add to :parent Dropdown menu
  menu :parent => "Articles"
  # menu :priority => 2
  
  # Filterable attributes
  filter :title
  filter :tags
  filter :contact_id
  filter :status

  
  # View 
  index do
    column :id
    column "Quick Answer Title", :title do |article|
      link_to article.title, [:admin, article]
    end
    column :category
    column :contact
    column "Created", :created_at
    column "Write-a-thon Author Name", :author_name
    column "Write-a-thon Author Link", :author_link
    # column :tags
    column :slug
    column "Status", :status
    default_actions # Add show, edit, delete column
  end

  form :partial => "form"
end
