class AddPublishedPendingReviewToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :published, :boolean
    add_column :articles, :pending_review, :boolean
  end
end
