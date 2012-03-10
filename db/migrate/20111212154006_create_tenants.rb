class CreateTenants < ActiveRecord::Migration
  def up
    create_table :tenants do |t|
      t.string   :name
      t.string   :subdomain
      t.string   :cname
      t.datetime :passive_at

      t.timestamps
    end

    add_index :tenants, :name, :unique => true
    add_index :tenants, :subdomain, :unique => true
    add_index :tenants, :cname, :unique => true
    add_index :tenants, :passive_at

  end

  def down
    drop_table :tenants
  end
end