class CreatePrivilegesRoles < ActiveRecord::Migration
  def up
    create_table :privileges_roles, :id => false do |t|
      t.integer :privilege_id,  :null => false
      t.integer :role_id,       :null => false
    end
    add_index :privileges_roles, [:privilege_id, :role_id], :unique => true

    # Tenants
    Tenant.current = Tenant.find(1)

    # Roles
    admin_role  = Role.find_by_name('Admin')
    user_role   = Role.find_by_name('User')

    # Privileges
    invite_user      = Privilege.find_by_sys_name('InviteUser')
    passive_user     = Privilege.find_by_sys_name('PassiveUser')
    active_user      = Privilege.find_by_sys_name('ActiveUser')
    manage_account   = Privilege.find_by_sys_name('ManageAccount')

    # Role Privileges
    admin_role.privileges << invite_user
    admin_role.privileges << manage_account
    admin_role.privileges << passive_user
    admin_role.privileges << active_user
    admin_role.save
  end

  def down
    remove_index :privileges_roles, :column => [:privilege_id, :role_id]
    drop_table   :privileges_roles
  end
end
