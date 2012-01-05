class CreatePrivilegesResources < ActiveRecord::Migration
  def up
    create_table :privileges_resources, :id => false do |t|
      t.integer :resource_id,   :null => false
      t.integer :privilege_id,  :null => false
    end
    add_index :privileges_resources, [:resource_id, :privilege_id], :unique => true
  end

  def down
    remove_index :privileges_resources, :column => [:resource_id, :privilege_id]
    drop_table   :privileges_resources
  end
end
