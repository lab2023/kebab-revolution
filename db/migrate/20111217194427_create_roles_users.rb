class CreateRolesUsers < ActiveRecord::Migration
  def up
    # Create the association table
    create_table :roles_users, :id => false do |t|
      t.integer :role_id, :null => false
      t.integer :user_id, :null => false
    end

    # Add table index
    add_index :roles_users, [:role_id, :user_id], :unique => true

    execute <<-SQL
      ALTER TABLE  `roles_users`
        ADD CONSTRAINT fk_roles_roles_users_id
        FOREIGN KEY (  `role_id` ) REFERENCES  `roles` ( `id` )
        ON DELETE RESTRICT ON UPDATE RESTRICT
    SQL

    execute <<-SQL
      ALTER TABLE  `roles_users`
      ADD CONSTRAINT fk_users_roles_users_id
      FOREIGN KEY (  `user_id` ) REFERENCES  `users` ( `id` )
      ON DELETE RESTRICT ON UPDATE RESTRICT
    SQL

    execute <<-SQL
      ALTER TABLE  `roles_users` CHANGE  `role_id`  `role_id` INT( 11 ) NOT NULL
    SQL

    execute <<-SQL
      ALTER TABLE  `roles_users` CHANGE  `user_id`  `user_id` INT( 11 ) NOT NULL
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE `roles_users` DROP FOREIGN KEY fk_role_roles_users_id
      ALTER TABLE `roles_users` DROP FOREIGN KEY fk_user_roles_users_id
    SQL

    remove_index :roles_users, :column => [:role_id, :user_id]
    drop_table :roles_users
  end
end
