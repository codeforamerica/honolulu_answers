class ChangeAdminToPublisherUsers < ActiveRecord::Migration
  def up
  	rename_column :users, :admin, :is_moderator
  end

  def down
  	rename_column :users, :is_moderator, :admin
  end
end
