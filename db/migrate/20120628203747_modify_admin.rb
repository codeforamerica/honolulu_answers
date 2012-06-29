class ModifyAdmin < ActiveRecord::Migration
  def up
  	remove_column :admins, :remember_created_at
  	## Lockable
    add_column :admins, :failed_attempts, :integer, :default => 5 # Only if lock strategy is :failed_attempts
    add_column :admins, :unlock_token, :string # Only if unlock strategy is :email or :both
    add_column :admins, :locked_at, :datetime 
  end

  def down
  	add_column :admins, :remember_created_at, :datetime
  	## Lockable
    drop_column :admins, :failed_attempts# Only if lock strategy is :failed_attempts
    drop_column :admins, :unlock_token # Only if unlock strategy is :email or :both
    drop_column :admins, :locked_at
  end
end
