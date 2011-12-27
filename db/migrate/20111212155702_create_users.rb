class CreateUsers < ActiveRecord::Migration
  def up
      create_table :users do |t|
        t.references :tenant
        t.string :name
        t.string :locale

        ## Database authenticatable
        t.string :email,              :null => false, :default => ""
        t.string :encrypted_password, :null => false, :default => ""

        ## Recoverable
        t.string   :reset_password_token
        t.datetime :reset_password_sent_at

        ## Rememberable
        t.datetime :remember_created_at

        ## Trackable
        t.integer  :sign_in_count, :default => 0
        t.datetime :current_sign_in_at
        t.datetime :last_sign_in_at
        t.string   :current_sign_in_ip
        t.string   :last_sign_in_ip

        ## Confirmable
        t.string   :confirmation_token
        t.datetime :confirmed_at
        t.datetime :confirmation_sent_at
        t.string   :unconfirmed_email # Only if using reconfirmable

        ## Lockable
        t.integer  :failed_attempts, :default => 0 # Only if lock strategy is :failed_attempts
        t.string   :unlock_token # Only if unlock strategy is :email or :both
        t.datetime :locked_at

        # Token authenticatable
        t.string :authentication_token

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