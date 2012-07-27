class ChangeContentTypeArticles < ActiveRecord::Migration
  def up
  	change_column :articles, :content_type, :string
  end

  def down
  	change_column :articles, :content_type, :integer
  end
end
