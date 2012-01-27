class CreatePayments < ActiveRecord::Migration
  def up
    create_table :payments do |t|
      t.references  :subscription
      t.decimal     :price, :precision => 6, :scale => 2
      t.datetime    :payment_date
      t.string      :invoice_no
      t.string      :transaction_id

      t.timestamps
    end
  end

  def down
    drop_table :payments
  end
end
