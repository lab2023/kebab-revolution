class CreateRolesUsers < ActiveRecord::Migration
  def up
    create_table :roles_users, :id => false do |t|
      t.integer :role_id, :null => false
      t.integer :user_id, :null => false
    end

    add_index :roles_users, [:role_id, :user_id], :unique => true
  end

  def down
    remove_index :roles_users, :column => [:role_id, :user_id]
    drop_table :roles_users
  end
end
