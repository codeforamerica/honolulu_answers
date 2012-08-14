class AddTypeToArticles < ActiveRecord::Migration
  def up
    add_column :articles, :type, :string
  end
  def down
    remove_column :articles, :type
  end
end
