class AddDivisionOfContentFieldsToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :content_main, :text
    add_column :articles, :content_main_extra, :text
    add_column :articles, :content_need_to_know, :text
  end
end
