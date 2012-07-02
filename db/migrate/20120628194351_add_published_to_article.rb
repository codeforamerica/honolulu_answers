class AddPublishedToArticle < ActiveRecord::Migration
  def up
    add_column :articles, :is_published, :boolean, :default => false
  end

  def down
    remove_column :articles, :is_published
  end
end
