class AddVotingToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :upvote, :integer
    add_column :articles, :downvote, :integer
  end
end
