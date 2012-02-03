namespace :kebab do
  desc 'Daily task that will handle subscriptions'
  task :notifier => :environment do

    # Send notifier before 10 days ago
    Subscription.find_trials_without_recurring_profile(10.days.from_now).each do |sub|
      exception_catcher { NotifierMailer.trial_10_days_from_now(sub).deliver }
    end

    # Send notifier before 5 days ago
    Subscription.find_trials_without_recurring_profile(5.days.from_now).each do |sub|
      exception_catcher { NotifierMailer.trial_5_days_from_now(sub).deliver }
    end

    # Cancel account which didn't start paypal recurring payment
    Subscription.find_finished_trials.each do |sub|
      passive_tenant sub.tenant_id
      exception_catcher { NotifierMailer.trial_cancel_tenant(sub).deliver }
    end

    # Send notifier after 5 days
    Subscription.find_payment_failures(5.days.ago).each do |sub|
      exception_catcher { NotifierMailer.payment_failures_5_days_ago(sub).deliver }
    end

    # Cancel account which didn't pay after 10 days
    Subscription.find_payment_failures(10.days.ago).each do |sub|
      passive_tenant sub.tenant_id
      exception_catcher { NotifierMailer.payment_failures_cancel_tenant(sub).deliver }
    end

    Rails.logger.info("Kebab notifier rake process is finished")
  end

  desc 'Check payment and update subscription and payment table'
  task :checker => :environment do

    # Check payment and update payment_period, next_payment_date and payment table
    Subscription.find_payment.each do |sub|
      ppr = PayPal::Recurring.new(:profile_id => sub.paypal_payment_token)
      paypal_payment_period = ppr.profile.completed

      if paypal_payment_period.to_i == sub.payment_period.to_i
        Subscription.transaction do
          subscription = Subscription.find_by_tenant_id sub.tenant_id
          subscription.next_payment_date =  sub.next_payment_date + 1.months
          subscription.payment_period = sub.payment_period + 1
          if subscription.save
            payment = Payment.new
            payment.subscription_id = subscription.id
            payment.price = ppr.profile.last_payment_amount
            payment.payment_date = ppr.profile.last_payment_date
            payment.save
          end
        end
      end
    end

    Rails.logger.info("Kebab checker rake process is finished")
  end

  # Cancel the tenant account
  def passive_tenant id
    @tenant = Tenant.find(id)
    @tenant.passive_at = Time.now
    if @tenant.save then true else false end
  end

  # Rescue the exception and write log file. Other way process is stopped.
  def exception_catcher
    begin
      yield
    rescue Exception => err
      Rails.logger.error("\nException in kebab rake: \n#{err.message}\n\t#{err.backtrace.join("\n\t")}\n")
    end
  end
end