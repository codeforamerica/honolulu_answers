class CreateKeywords < ActiveRecord::Migration
  def change
    create_table :keywords do |t|
      t.string :name
      t.string :metaphone
      t.string :stem
      t.text :synonyms

      t.timestamps
    end
  end
end
