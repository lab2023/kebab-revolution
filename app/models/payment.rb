# Kebab 2.0 - Server Ror
#
# Author::    Onur Özgür ÖZKAN <onur.ozgur.ozkan@lab2023.com>
# Copyright:: Copyright (c) 2011 lab2023 - internet technologies
# License::   Distributes under MIT

# Payment Model
class Payment < ActiveRecord::Base
  belongs_to :subscription

  validates  :subscription,                           :presence => true
  validates  :price,                                  :presence => true
  validates  :payment_date,                           :presence => true
  validates  :invoice_no,                             :presence => true
  validates  :paypal_recurring_payment_profile_token, :presence => true

  before_validation :set_invoice_no

  # Set Invoice No
  def set_invoice_no
    self.invoice_no = Payment.last.nil? ? Kebab.invoice_no : Payment.last.invoice_no.to_i + 1
  end
end
