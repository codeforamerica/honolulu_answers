class CreateWordcounts < ActiveRecord::Migration
  def change
    create_table :wordcounts do |t|
      t.integer :article_id
      t.integer :keyword_id
      t.integer :count

      t.timestamps
    end
  end
end
