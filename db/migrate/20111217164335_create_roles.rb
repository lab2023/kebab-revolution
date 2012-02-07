class CreateRoles < ActiveRecord::Migration
  def up
    create_table :roles do |t|
      t.references :tenant
      t.string     :name

      t.timestamps
    end

    # add initial data
    Role.create!(name: 'Admin')
    Role.create!(name: 'User')
  end

  def down
    drop_table :roles
  end
end
