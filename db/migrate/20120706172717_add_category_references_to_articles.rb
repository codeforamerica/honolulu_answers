class AddCategoryReferencesToArticles < ActiveRecord::Migration
  def up
    change_table :articles do |t|
      t.remove :category
      t.references :category
    end
  end

  def down
    change_table :articles do |t|
      t.remove :category
      t.string :category
    end
  end
end
