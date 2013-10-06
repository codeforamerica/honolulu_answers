class RemoveLegacyContentFieldsFromArticle < ActiveRecord::Migration
  def change
    remove_column :articles, :render_markdown
    remove_column :articles, :content_md
    remove_column :articles, :content
  end
end
