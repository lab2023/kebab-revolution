class CreatePrivilegesResources < ActiveRecord::Migration
  def up
    create_table :privileges_resources, :id => false do |t|
      t.integer :resource_id,   :null => false
      t.integer :privilege_id,  :null => false
    end

    add_index :privileges_resources, [:resource_id, :privilege_id], :unique => true

    execute <<-SQL
      ALTER TABLE `privileges_resources`
        ADD CONSTRAINT `fk_resources_privileges_resources`
        FOREIGN KEY (`resource_id`) REFERENCES `resources` ( `id` )
        ON DELETE RESTRICT ON UPDATE RESTRICT
    SQL

    execute <<-SQL
      ALTER TABLE `privileges_resources`
        ADD CONSTRAINT `fk_privileges_privileges_resources`
        FOREIGN KEY ( `privilege_id` ) REFERENCES `privileges` ( `id` )
        ON DELETE RESTRICT ON UPDATE RESTRICT
    SQL

    execute <<-SQL
      ALTER TABLE `privileges_resources` CHANGE `resource_id` `resource_id` INT ( 11 ) NOT NULL
    SQL

    execute <<-SQL
      ALTER TABLE `privileges_resources` CHANGE `privilege_id` `privilege_id` INT ( 11 ) NOT NULL
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE `privileges_resources` DROP FOREIGN KEY fk_resources_privileges_resources
    SQL

    execute <<-SQL
      ALTER TABLE `privileges_resources` DROP FOREIGN KEY fk_privileges_privileges_resources
    SQL

    remove_index :privileges_resources, :column => [:resource_id, :privilege_id]

    drop_table   :privileges_resources
  end
end
