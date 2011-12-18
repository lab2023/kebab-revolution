class CreateAppsPrivileges < ActiveRecord::Migration
  def up
    create_table :apps_privileges, :id => false do |t|
      t.integer :app_id,        :null => false
      t.integer :privilege_id,  :null => false
    end

    add_index :apps_privileges, [:app_id, :privilege_id], :unique => true

    execute <<-SQL
      ALTER TABLE `apps_privileges`
        ADD CONSTRAINT `fk_apps_apps_privileges`
        FOREIGN KEY ( `app_id` ) REFERENCES `apps` ( `id` )
        ON DELETE RESTRICT ON UPDATE RESTRICT
    SQL

    execute <<-SQL
      ALTER TABLE `apps_privileges`
        ADD CONSTRAINT `fk_privileges_apps_privileges`
        FOREIGN KEY ( `privilege_id` ) REFERENCES `privileges` ( `id` )
        ON DELETE RESTRICT ON UPDATE RESTRICT
    SQL

    execute <<-SQL
      ALTER TABLE `apps_privileges` CHANGE `app_id` `app_id` INT ( 11 ) NOT NULL
    SQL

    execute <<-SQL
      ALTER TABLE `apps_privileges` CHANGE `privilege_id` `privilege_id` INT ( 11 ) NOT NULL
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE `apps_privileges` DROP FOREIGN KEY fk_apps_apps_privileges
    SQL

    execute <<-SQL
      ALTER TABLE `apps_privileges` DROP FOREIGN KEY fk_privileges_apps_privileges
    SQL

    remove_index :apps_privileges, :column => [:app_id, :privilege_id]

    drop_table   :apps_privileges
  end
end
