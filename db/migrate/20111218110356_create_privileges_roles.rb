class CreatePrivilegesRoles < ActiveRecord::Migration
  def up
    # Create the association table
    create_table :privileges_roles, :id => false do |t|
      t.integer :privilege_id,  :null => false
      t.integer :role_id,       :null => false
    end

    # Add table index
    add_index :privileges_roles, [:privilege_id, :role_id], :unique => true

    # Add foreign keys and set not null
    execute <<-SQL
      ALTER TABLE `privileges_roles`
        ADD CONSTRAINT fk_privileges_privileges_roles_id
        FOREIGN KEY ( `privilege_id` ) REFERENCES `roles` ( `id` )
        ON DELETE RESTRICT ON UPDATE RESTRICT
    SQL

    execute <<-SQL
      ALTER TABLE `privileges_roles` CHANGE `privilege_id` `privilege_id` INT ( 11 ) NOT NULL
    SQL

    execute <<-SQL
      ALTER TABLE `privileges_roles`
        ADD CONSTRAINT fk_roles_privileges_roles_id
        FOREIGN KEY ( `role_id` ) REFERENCES `roles` ( `id` )
        ON DELETE RESTRICT ON UPDATE RESTRICT
    SQL

    execute <<-SQL
      ALTER TABLE `privileges_roles` CHANGE `role_id` `role_id` INT ( 11 ) NOT NULL
    SQL
  end

  def down
    # drop foreign keys
    execute <<-SQL
      ALTER TABLE `privileges_roles` DROP FOREIGN KEY fk_privileges_privileges_roles_id
    SQL

    execute <<-SQL
      ALTER TABLE `privileges_roles` DROP FOREIGN KEY fk_roles_privileges_roles_id
    SQL

    remove_index :privileges_roles, :column => [:privilege_id, :role_id]

    drop_table   :privileges_roles
  end
end
