class AddAuthorPictureNameToArticles < ActiveRecord::Migration
  def up
    add_attachment :articles, :author_pic
    add_column :articles, :author_name, :string
    add_column :articles, :author_link, :string
  end

  def down
    remove_attachment :articles, :author_pic
    remove_column :articles, :author_name
    remove_column :articles, :author_link
  end
end
