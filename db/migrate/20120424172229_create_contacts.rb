class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :subname
      t.string :number
      t.string :url
      t.string :address
      t.string :department
      t.text :description

      t.timestamps
    end
  end
end
