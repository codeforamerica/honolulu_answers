class RemoveStatusFromArticle < ActiveRecord::Migration
  def change
    remove_column :articles, :status
  end
end
