# email: "oozgurozkan@gmail.com",
# locale: "tr",
# next_payment_date: "2012-01-24T00:48:39Z",
# plan_name: "Basic",
# price: "99.0",
# user_name: "Onur Ozgur OZKAN"
class NotifierMailer < ActionMailer::Base
  default from: "onur.ozgur.ozkan@lab2023.com"

  # Before 10 days
  def trial_10_days_from_now subscription
    I18n.locale = subscription.locale
    @subscription = subscription
    mail(:to => @subscription.email, :subject => "Start your paypay recurring payment")
  end

  # Before 5 days
  def trial_5_days_from_now subscription
    I18n.locale = subscription.locale
    @subscription = subscription
    mail(:to => @subscription.email, :subject => "Start your paypay recurring payment")
  end

  # The same time
  def trial_cancel_tenant subscription
    I18n.locale = subscription.locale
    @subscription = subscription
    mail(:to => @subscription.email, :subject => "Cancel your trial account")
  end

  # After 5 days
  def payment_failures_5_days_ago subscription
    I18n.locale = subscription.locale
    @subscription = subscription
    mail(:to => @subscription.email, :subject => "Payment Failures")
  end

  # After 10 days
  def payment_failures_cancel_tenant subscription
    I18n.locale = subscription.locale
    @subscription = subscription
    mail(:to => @subscription.email, :subject => "Cancel your account")
  end
end
