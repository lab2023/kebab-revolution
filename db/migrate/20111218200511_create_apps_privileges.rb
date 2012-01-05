class CreateAppsPrivileges < ActiveRecord::Migration
  def up
    create_table :apps_privileges, :id => false do |t|
      t.integer :app_id,        :null => false
      t.integer :privilege_id,  :null => false
    end
    add_index :apps_privileges, [:app_id, :privilege_id], :unique => true
  end

  def down
    remove_index :apps_privileges, :column => [:app_id, :privilege_id]
    drop_table   :apps_privileges
  end
end
