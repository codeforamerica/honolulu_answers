class CreateGuides < ActiveRecord::Migration
  def change
    create_table :guides do |t|
      t.string :title
      t.text :content
  	  t.text :preview
      t.integer :contact_id
      t.text :tags
      t.integer :category_id
      t.timestamps
    end
  end
end