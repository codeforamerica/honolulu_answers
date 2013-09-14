class PopulatePublishedPendingReviewWithStatusOnArticle < ActiveRecord::Migration
  def self.up
    Article.all.each do |article|
      article.published = !!article.published?
      article.pending_review = !!article.pending_review?
      article.save
    end
  end

  def self.down
    Article.all.each do |article|
      if article.published
        article.status = "Published"
      elsif article.pending_review
        article.status = "Pending Review"
      else
        article.status = "Draft"
      end
      article.save
    end
  end
end
