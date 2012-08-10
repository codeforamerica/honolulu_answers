class CreateGuideSteps < ActiveRecord::Migration
  def change
    create_table :guide_steps do |t|
      t.integer :article_id
      t.string :title
      t.text :content
  	  t.text :preview
  	  t.integer :step
      t.timestamps
    end
  end
end
