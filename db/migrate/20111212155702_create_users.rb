class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.references :tenant
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :time_zone
      t.string :locale
      t.boolean :disabled, :default => true

      t.timestamps
    end

    add_index :users, :tenant_id
    add_index :users, :email, :unique => true

  end

  def down
    drop_table :users
  end
end