# encoding: utf-8
namespace :dev do

  desc "Setup db. Drop, create, migrate, dev:seed"
  task :setup => :environment do
    Rake::Task['db:drop'].execute
    Rake::Task['db:create'].execute
    Rake::Task['db:migrate'].execute
    Rake::Task['dev:seed'].execute
  end

  desc "Setup seed data for development env."
  task :seed => :environment do
    I18n.locale = :en

    # Tenant
    lab2023 = Tenant.create!(name: 'lab2023 Inc.', subdomain: 'lab2023')
    apple   = Tenant.create!(name: 'Apple Inc.', subdomain: 'apple')

    # User
    onur =   User.create!(name: 'Onur Ozgur OZKAN',   email: 'onur@ozgur.com',  password: '123456', password_confirmation: '123456', locale: 'en', time_zone: 'Istanbul', tenant_id: 1)
    tayfun = User.create!(name: 'Tayfun Ozis ERIKAN', email: 'tayfun@ozis.com', password: '123456', password_confirmation: '123456', locale: 'en', time_zone: 'Istanbul', tenant_id: 1)

    # Roles
    admin_role = Role.create!(name: 'Admin', tenant_id: 1)

    # User Role Relation
    onur.roles << admin_role
    onur.save

    # Privileges
    invite_user       = Privilege.find_by_sys_name('InviteUser')
    passive_user      = Privilege.find_by_sys_name('PassiveUser')
    active_user       = Privilege.find_by_sys_name('ActiveUser')
    manage_account    = Privilege.find_by_sys_name('ManageAccount')

    # Role Privileges
    admin_role.privileges << invite_user
    admin_role.privileges << manage_account
    admin_role.privileges << passive_user
    admin_role.privileges << active_user
    admin_role.save


    # Subscription
    plan_2 = Plan.find(2)
    subscription = Subscription.create!(plan_id: plan_2.id, tenant_id: 1, user_id: 1, price: plan_2.price, user_limit: plan_2.user_limit, payment_period: 1, next_payment_date: Time.zone.now + 1.months)

    # Payments
    Payment.create!(price: 99, payment_date: Time.now - 1.months, subscription: subscription)
    Payment.create!(price: 99, payment_date: Time.now - 2.months, subscription: subscription)
    Payment.create!(price: 99, payment_date: Time.now - 3.months, subscription: subscription)
    Payment.create!(price: 99, payment_date: Time.now - 4.months, subscription: subscription)
    Payment.create!(price: 99, payment_date: Time.now - 5.months, subscription: subscription)
  end

end