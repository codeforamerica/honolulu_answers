class RemoveIsPublishedFieldFromArticles < ActiveRecord::Migration
  def up
    remove_column :articles, :is_published
  end

  def down
    add_column :articles, :is_published, :boolean, :default => false
  end
end
