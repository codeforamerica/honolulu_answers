class FixNamingConventionsOnRoles < ActiveRecord::Migration
  def up
    rename_column :users, :is_editor, :is_writer
    rename_column :users, :is_moderator, :is_editor
  end

  def down
    rename_column :users, :is_editor, :is_moderator
    rename_column :users, :is_writer, :is_editor
  end
end
