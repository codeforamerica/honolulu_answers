class AddAccessCountToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :access_count, :integer, :default => 0
  end
end
