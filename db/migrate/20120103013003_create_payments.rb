class CreatePayments < ActiveRecord::Migration
  def up
    create_table :payments do |t|
      t.references  :subscription
      t.decimal     :amount
      t.datetime    :payment_date
      t.string      :paypal_recurring_payment_profile_token

      t.timestamps
    end
  end

  def down
    drop_table :payments
  end
end
