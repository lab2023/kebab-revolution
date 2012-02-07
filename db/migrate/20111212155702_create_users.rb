class CreateUsers < ActiveRecord::Migration
  def up
      create_table :users do |t|
        t.references :tenant
        t.string :name
        t.string :email
        t.string :password_digest
        t.string :time_zone
        t.string :locale
        t.datetime :passive_at

        t.timestamps
      end

      add_index :users, :tenant_id
      add_index :users, :email, :unique => true

      # Add initial data
      Tenant.current = Tenant.find(1)
      User.create!(name: 'Onur Ozgur OZKAN',   email: 'onur@ozgur.com',  password: '123456', password_confirmation: '123456', locale: 'tr', time_zone: 'Istanbul')
      User.create!(name: 'Tayfun Ozis ERIKAN', email: 'tayfun@ozis.com', password: '123456', password_confirmation: '123456', locale: 'tr', time_zone: 'Istanbul')
  end

  def down
    drop_table :users
  end
end