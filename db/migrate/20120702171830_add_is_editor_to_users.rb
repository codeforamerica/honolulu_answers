class AddIsEditorToUsers < ActiveRecord::Migration
  def up
  	add_column :users, :is_editor, :boolean, :default => false
  end
  def down
  	remove_column :users, :is_editor
  end
end
