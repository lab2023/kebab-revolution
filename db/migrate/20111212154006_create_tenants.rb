class CreateTenants < ActiveRecord::Migration
  def up
    create_table :tenants do |t|
      t.string   :name
      t.string   :host
      t.datetime :passive_at

      t.timestamps
    end

    add_index :tenants, :name, :unique => true
    add_index :tenants, :host, :unique => true
    add_index :tenants, :passive_at

    # Add initial data
    Tenant.create!(name: 'lab2023 Inc.', host: "lab2023.#{Kebab.application_url.to_s}")
  end

  def down
    drop_table :tenants
  end
end