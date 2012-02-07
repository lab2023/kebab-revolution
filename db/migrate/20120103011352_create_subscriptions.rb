class CreateSubscriptions < ActiveRecord::Migration
  def up
    create_table :subscriptions do |t|
      t.references  :plan
      t.references  :tenant
      t.references  :user
      t.decimal     :price, :precision => 6, :scale => 2
      t.integer     :user_limit
      t.integer     :payment_period
      t.datetime    :next_payment_date
      t.string      :paypal_token
      t.string      :paypal_customer_token
      t.string      :paypal_payment_token

      t.timestamps
    end

    # add data
    plan_2 = Plan.find(2)
    Subscription.create!(plan_id: plan_2.id, tenant_id: 1, user_id: 1, price: plan_2.price, user_limit: plan_2.user_limit, payment_period: 1, next_payment_date: Time.zone.now + 1.months)
  end

  def down
    drop_table :subscriptions
  end
end
