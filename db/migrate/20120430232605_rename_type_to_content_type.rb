class RenameTypeToContentType < ActiveRecord::Migration
  def up

    rename_column :articles, :type, :content_type
    
  end

  def down
  end
end
