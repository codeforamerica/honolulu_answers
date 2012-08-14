class DropGuidesTable < ActiveRecord::Migration
  def change
  	drop_table :guides
  end

end
