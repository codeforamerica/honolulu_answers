class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.datetime :updated
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
