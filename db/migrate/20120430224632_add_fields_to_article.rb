class AddFieldsToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :category, :string
    add_column :articles, :type, :int
    add_column :articles, :preview, :text
    add_column :articles, :contact_id, :int
    add_column :articles, :tags, :text
    add_column :articles, :service_url, :string

  end
end
