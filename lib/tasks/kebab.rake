namespace :kebab do
  desc 'Daily task that will handle subscriptions'
  task :notifier => :environment do

    # Rescue the exception and write log file. Other way process is stopped.
    def exception_catcher
      begin
        yield
      rescue Exception => err
        Rails.logger.error("\nException in notifier: \n#{err.message}\n\t#{err.backtrace.join("\n\t")}\n")
      end
    end

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
  end

  # Cancel the tenant account
  def passive_tenant id
    @tenant = Tenant.find(id)
    @tenant.passive_at = Time.now
    if @tenant.save then true else false end
  end
end