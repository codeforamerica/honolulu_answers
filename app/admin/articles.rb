ActiveAdmin.register Article do

  index do
    column :id
    column "Article Title", :title do |article|
      link_to article.title, [:admin, article]
    end
    column :category
    column "Created", :created_at
    # column :tags
    column :slug
    column "Published", :is_published
    default_actions # Add show, edit, delete column
  end
  
  filter :title
  filter :tags
  filter :contact_id
  filter :is_published
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