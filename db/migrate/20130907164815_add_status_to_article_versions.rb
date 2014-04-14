class AddStatusToArticleVersions < ActiveRecord::Migration
  def change
    add_column :article_versions, :status, :string
  end
end
