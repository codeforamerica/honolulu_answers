class RenameAdminsToAdministrators < ActiveRecord::Migration
  def up
  	rename_table :admins, :administrators
  end

  def down
  	rename_table :administrators, :admins
  end
end
