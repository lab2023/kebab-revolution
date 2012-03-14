class CreatePrivilegesRoles < ActiveRecord::Migration
  def up
    create_table :privileges_roles, :id => false do |t|
      t.integer :privilege_id,  :null => false
      t.integer :role_id,       :null => false
    end
    add_index :privileges_roles, [:privilege_id, :role_id], :unique => true

  end

  def down
    remove_index :privileges_roles, :column => [:privilege_id, :role_id]
    drop_table   :privileges_roles
  end
end
