ActiveAdmin.register Guide do
# This will authorize the Foobar class
  # The authorization is done using the AdminAbility class
  controller.authorize_resource
  
  # Filterable attributes
  filter :title
  filter :tags
  filter :contact_id
  filter :is_published

  
  # View 
  index do
    column :id
    column "Guide Title", :title do |guide|
      link_to guide.title, [:admin, guide]
    end
    column :category
    column :content_type
    column "Created", :created_at
    column "Author name", :author_name
    column "Author picture", :author_pic
    column "Author URL", :author_link
    # column :tags
    column :slug
    column "Published", :is_published
    default_actions # Add show, edit, delete column
  end
  
  form do |f|   # create/edit user form
    f.inputs "Guide Details" do
      if current_user.is_moderator
        f.input :is_published, :label => "Publish?"
      end     
      f.input :title
      f.input :content# , :input_html => {:class => 'editor'}
      f.input :preview
      f.input :category
      #f.input :content_type,  :as => :select, :collection => ["Quick Answer", "Web Service", "Guide"]
      f.input :contact
      #f.input :service_url
      f.input :tags, :as => :string 
      f.input :author_link
      f.input :author_pic
      f.input :author_name

    end
    f.buttons
  end
end
