class CreateUsers < ActiveRecord::Migration
  def up
      create_table :users do |t|
        t.references :tenant
        t.string :name
        t.string :email
        t.string :password_digest

        t.timestamps
      end

      add_index :users, :tenant_id
      add_index :users, :email, :unique => true

      # add foreign key and make tenant_id not null
      execute <<-SQL
        ALTER TABLE  `users`
          ADD CONSTRAINT fk_tenants_users_id
          FOREIGN KEY (  `tenant_id` ) REFERENCES  `tenants` ( `id` )
          ON DELETE RESTRICT ON UPDATE RESTRICT
      SQL

      # add tenant_id not null
      execute <<-SQL
        ALTER TABLE  `users` CHANGE  `tenant_id`  `tenant_id` INT( 11 ) NOT NULL
      SQL
  end

    def down
      execute <<-SQL
        ALTER TABLE `users` DROP FOREIGN KEY fk_tenants_users_id
      SQL

      drop_table :users
    end
end
