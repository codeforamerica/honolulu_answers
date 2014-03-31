class AddRenderMarkdownToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :render_markdown, :boolean, :default => true
  end
end
