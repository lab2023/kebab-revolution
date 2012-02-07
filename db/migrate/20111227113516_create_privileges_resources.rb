class CreatePrivilegesResources < ActiveRecord::Migration
  def up
    create_table :privileges_resources, :id => false do |t|
      t.integer :resource_id,   :null => false
      t.integer :privilege_id,  :null => false
    end
    add_index :privileges_resources, [:resource_id, :privilege_id], :unique => true

    # Priviliges
    invite_user = Privilege.find_by_sys_name('InviteUser')
    passive_user = Privilege.find_by_sys_name('PassiveUser')
    active_user = Privilege.find_by_sys_name('ActiveUser')
    manage_account   = Privilege.find_by_sys_name('ManageAccount')

    # Application
    user_manager    = Application.find_by_sys_name('UserManager')
    account_manager = Application.find_by_sys_name('AccountManager')

    # Resources
    users_post      = Resource.find_by_sys_name('users.create')
    users_get       = Resource.find_by_sys_name('users.index')
    users_passive   = Resource.find_by_sys_name('users.passive')
    users_active    = Resource.find_by_sys_name('users.active')

    accounts_delete         = Resource.find_by_sys_name('tenants.destroy')                                # Delete account
    paypal_payment_success  = Resource.find_by_sys_name('subscriptions.paypal_recurring_payment_success') # Paypal success recurring payment return page
    paypal_payment_failed   = Resource.find_by_sys_name('subscriptions.paypal_recurring_payment_failed')  # Paypal failed  recurring payment return page
    paypal_credential       = Resource.find_by_sys_name('subscriptions.paypal_credential')                # Paypal paypal_credential ajax
    next_subscription       = Resource.find_by_sys_name('subscriptions.next_subscription')                # Next subscription
    payments                = Resource.find_by_sys_name('subscriptions.payments')                         # All payments
    plans                   = Resource.find_by_sys_name('subscriptions.plans')                            # All plans
    update_plan             = Resource.find_by_sys_name('subscriptions.update')                           # Update plan

    # Application Priviliges Resource Relation
    invite_user.applications << user_manager
    invite_user.resources    << users_post
    invite_user.resources    << users_get
    invite_user.save

    passive_user.applications << user_manager
    passive_user.resources    << users_passive
    passive_user.save

    active_user.applications << user_manager
    active_user.resources    << users_active
    active_user.save

    manage_account.applications << account_manager
    manage_account.resources    << accounts_delete
    manage_account.resources    << paypal_payment_failed
    manage_account.resources    << paypal_payment_success
    manage_account.resources    << paypal_credential
    manage_account.resources    << next_subscription
    manage_account.resources    << payments
    manage_account.resources    << plans
    manage_account.resources    << update_plan
    manage_account.save
  end

  def down
    remove_index :privileges_resources, :column => [:resource_id, :privilege_id]
    drop_table   :privileges_resources
  end
end
