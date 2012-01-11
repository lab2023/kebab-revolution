class CreateApplicationsPrivileges < ActiveRecord::Migration
  def up
    create_table :applications_privileges, :id => false do |t|
      t.integer :application_id, :null => false
      t.integer :privilege_id,   :null => false
    end
    add_index :applications_privileges, [:application_id, :privilege_id], :unique => true
  end

  def down
    remove_index :applications_privileges, :column => [:application_id, :privilege_id]
    drop_table   :applications_privileges
  end
end
