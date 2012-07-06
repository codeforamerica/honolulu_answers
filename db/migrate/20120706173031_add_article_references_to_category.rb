class AddArticleReferencesToCategory < ActiveRecord::Migration
  def change
    change_table :categories do |t|
      t.references :article
    end
  end
end
