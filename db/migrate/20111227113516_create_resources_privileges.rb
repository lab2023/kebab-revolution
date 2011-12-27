class CreateResourcesPrivileges < ActiveRecord::Migration
  def up
    create_table :resources_privileges, :id => false do |t|
      t.integer :resource_id,   :null => false
      t.integer :privilege_id,  :null => false
    end

    add_index :resources_privileges, [:resource_id, :privilege_id], :unique => true

    execute <<-SQL
      ALTER TABLE `resources_privileges`
        ADD CONSTRAINT `fk_resources_resources_privileges`
        FOREIGN KEY (`resource_id`) REFERENCES `resources` ( `id` )
        ON DELETE RESTRICT ON UPDATE RESTRICT
    SQL

    execute <<-SQL
      ALTER TABLE `resources_privileges`
        ADD CONSTRAINT `fk_privileges_resources_privileges`
        FOREIGN KEY ( `privilege_id` ) REFERENCES `privileges` ( `id` )
        ON DELETE RESTRICT ON UPDATE RESTRICT
    SQL

    execute <<-SQL
      ALTER TABLE `resources_privileges` CHANGE `resource_id` `resource_id` INT ( 11 ) NOT NULL
    SQL

    execute <<-SQL
      ALTER TABLE `resources_privileges` CHANGE `privilege_id` `privilege_id` INT ( 11 ) NOT NULL
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE `resources_privileges` DROP FOREIGN KEY fk_resources_resources_privileges
    SQL

    execute <<-SQL
      ALTER TABLE `resources_privileges` DROP FOREIGN KEY fk_privileges_resources_privileges
    SQL

    remove_index :resources_privileges, :column => [:resource_id, :privilege_id]

    drop_table   :resources_privileges
  end
end
