class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.integer :yes_count
      t.integer :no_count
      t.references :article

      t.timestamps
    end
  end
end
