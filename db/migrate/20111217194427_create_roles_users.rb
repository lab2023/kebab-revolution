class CreateRolesUsers < ActiveRecord::Migration
  def up
    create_table :roles_users, :id => false do |t|
      t.integer :role_id, :null => false
      t.integer :user_id, :null => false
    end

    add_index :roles_users, [:role_id, :user_id], :unique => true

    # User Role Relation
    Tenant.current = Tenant.find(1)
    admin_role  = Role.find_by_name('Admin')
    user_role   = Role.find_by_name('User')

    onur = User.find(1)
    onur.roles << admin_role
    onur.roles << user_role
    onur.save

    tayfun = User.find(2)
    tayfun.roles << user_role
    tayfun.save
  end

  def down
    remove_index :roles_users, :column => [:role_id, :user_id]
    drop_table :roles_users
  end
end
