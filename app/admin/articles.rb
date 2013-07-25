ActiveAdmin.register Article do

  # This will authorize the Foobar class
  # The authorization is done using the AdminAbility class
  controller.authorize_resource
  
  # Add to :parent Dropdown menu
  # menu :parent => "Articles"
  # menu :priority => 1
  # Initialize tinymce
  # tinymce_assets
  # tinymce
  
  # Filterable attributes
  filter :title
  filter :tags
  filter :contact_id
  filter :status

  scope :all, :default => true do |articles|
    articles.includes [:category, :feedback]
  end
  
  # View 
  index do
    #column :id
    column "Article Title", :title do |article|
      link_to article.title, [:admin, article]
    end
    column :category, :sortable => 'categories.name'
    column :type
    column "Created", :created_at
    column "Author name", :author_name
    # column "Author picture", :author_pic
    # column "Author URL", :author_link
    # column :tags
    # column :slug
    column "Status", :status
    default_actions # Add show, edit, delete column
  end
  
  form do |f|   # create/edit user form
    f.inputs "Article Details" do
      if params[:action] == 'new'
        f.input :user_id, :as => :hidden, :input_html => { :value => current_user.id }
      end
      if current_user.is_writer?
        f.input :status,  :as => :select, :collection => ["Draft", "Pending Review"]
      else
        f.input :status,  :as => :select, :collection => ["Draft", "Pending Review", "Published"]
      end
      f.input :title
      f.input :content, :input_html => {:class => 'editor'}
      f.input :preview
      f.input :category
      #f.input :content_type,  :as => :select, :collection => ["Quick Answer", "Web Service", "Guide"]
      f.input :type,  :as => :select, :collection => ["QuickAnswer", "Resource", "Guide"]
      f.input :contact
      f.input :tags, :as => :string, :label => "Keywords"
      f.input :author_link
      #f.input :author_pic
      f.input :author_name
    end
    f.buttons
  end

end
# == Schema Information
#
# Table name: articles
#
#  id           :integer         not null, primary key
#  updated      :datetime
#  title        :string(255)
#  content      :text
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  category     :string(255)
#  content_type :integer
#  preview      :text
#  contact_id   :integer
#  tags         :text
#
