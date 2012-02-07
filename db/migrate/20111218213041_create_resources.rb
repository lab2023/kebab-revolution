class CreateResources < ActiveRecord::Migration
  def up
    create_table :resources do |t|
      t.string :sys_name
    end
    add_index :resources, :sys_name

    Resource.create!(sys_name: 'tenants.destroy')                                # Delete account
    Resource.create!(sys_name: 'subscriptions.paypal_recurring_payment_success') # Paypal success recurring payment return page
    Resource.create!(sys_name: 'subscriptions.paypal_recurring_payment_failed')  # Paypal failed  recurring payment return page
    Resource.create!(sys_name: 'subscriptions.paypal_credential')                # Paypal paypal_credential ajax
    Resource.create!(sys_name: 'subscriptions.next_subscription')                # Next subscription
    Resource.create!(sys_name: 'subscriptions.payments')                         # All payments
    Resource.create!(sys_name: 'subscriptions.plans')                            # All plans
    Resource.create!(sys_name: 'subscriptions.update')                           # Update plan
    Resource.create!(sys_name: 'users.create')
    Resource.create!(sys_name: 'users.index')
    Resource.create!(sys_name: 'users.passive')
    Resource.create!(sys_name: 'users.active')
  end

  def down
    drop_table  :resources
  end
end
