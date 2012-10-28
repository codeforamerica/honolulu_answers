class RemoveTitleFromQuestions < ActiveRecord::Migration
  def up
    remove_column :questions, :title
  end

  def down
  end
end
