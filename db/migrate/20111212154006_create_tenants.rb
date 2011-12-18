class CreateTenants < ActiveRecord::Migration
  def change
    create_table :tenants do |t|
      t.string  :name
      t.string  :host
      t.integer :owner_id

      t.timestamps
    end

    add_index :tenants, :name, :unique => true
    add_index :tenants, :host, :unique => true
  end
end