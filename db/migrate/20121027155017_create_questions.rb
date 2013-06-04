class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :question
      t.string :name
      t.string :email
      t.string :location
      t.string :context
      t.string :urgency
      t.string :status
      t.integer :answer

      t.timestamps
    end
  end
end
