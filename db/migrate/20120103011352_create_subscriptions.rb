class CreateSubscriptions < ActiveRecord::Migration
  def up
    create_table :subscriptions do |t|
      t.references  :plan
      t.references  :tenant
      t.references  :user
      t.decimal     :price, :precision => 6, :scale => 2
      t.integer     :billing_no
      t.integer     :payment_period
      t.datetime    :next_payment_date
      t.string      :paypal_token
      t.string      :paypal_customer_token
      t.string      :paypal_recurring_payment_profile_token

      t.timestamps
    end
  end

  def down
    drop_table :subscriptions
  end
end
