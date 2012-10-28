class RemoveExcessFieldsAndAddQuestionStatusOnQuestion < ActiveRecord::Migration
  def up
    remove_column :questions, :status
    remove_column :questions, :answer
    add_column :questions, :question_status, :string, :default => 'new'
  end

  def down
  end
end
