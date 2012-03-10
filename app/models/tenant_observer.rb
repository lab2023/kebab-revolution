# encoding: utf-8
class TenantObserver < ActiveRecord::Observer
  def after_create(tenant)
    tenant.logger.info "New tenant is created. #{tenant.as_json}"

    # Privileges
    #invite_user       = Privilege.find_by_sys_name('InviteUser')
    #passive_user      = Privilege.find_by_sys_name('PassiveUser')
    #active_user       = Privilege.find_by_sys_name('ActiveUser')
    #manage_account    = Privilege.find_by_sys_name('ManageAccount')

    # User Role
    user_role = Role.new
    user_role.name = 'User'
    user_role.tenant = tenant
    #user_role.privileges << example_privileges
    user_role.save
   end
end
