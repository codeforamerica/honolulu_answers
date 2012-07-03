ActiveAdmin.register Article do
  
  index do # Display only specific article db columns
    column :id
    column :title
    column :category
    column "Created", :created_at
    column :tags
    column :slug
    column "Published", :is_published
  end
  # default_actions # Add show, edit, delete column
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
#  service_url  :string(255)
#