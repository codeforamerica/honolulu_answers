class AddAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :bool

  end
end
