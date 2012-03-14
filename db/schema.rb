# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120103013003) do

  create_table "applications", :force => true do |t|
    t.string "sys_name"
    t.string "sys_department"
  end

  create_table "applications_privileges", :id => false, :force => true do |t|
    t.integer "application_id", :null => false
    t.integer "privilege_id",   :null => false
  end

  add_index "applications_privileges", ["application_id", "privilege_id"], :name => "index_applications_privileges_on_application_id_and_privilege_id", :unique => true

  create_table "payments", :force => true do |t|
    t.integer  "subscription_id"
    t.decimal  "price",           :precision => 6, :scale => 2
    t.datetime "payment_date"
    t.string   "invoice_no"
    t.string   "transaction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plans", :force => true do |t|
    t.string  "name"
    t.decimal "price",         :precision => 6, :scale => 2
    t.integer "user_limit"
    t.integer "machine_limit"
    t.boolean "recommended",                                 :default => false
  end

  create_table "privilege_translations", :force => true do |t|
    t.integer  "privilege_id"
    t.string   "locale"
    t.string   "name"
    t.text     "info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "privilege_translations", ["privilege_id"], :name => "index_privilege_translations_on_privilege_id"

  create_table "privileges", :force => true do |t|
    t.string "sys_name"
  end

  create_table "privileges_resources", :id => false, :force => true do |t|
    t.integer "resource_id",  :null => false
    t.integer "privilege_id", :null => false
  end

  add_index "privileges_resources", ["resource_id", "privilege_id"], :name => "index_privileges_resources_on_resource_id_and_privilege_id", :unique => true

  create_table "privileges_roles", :id => false, :force => true do |t|
    t.integer "privilege_id", :null => false
    t.integer "role_id",      :null => false
  end

  add_index "privileges_roles", ["privilege_id", "role_id"], :name => "index_privileges_roles_on_privilege_id_and_role_id", :unique => true

  create_table "resources", :force => true do |t|
    t.string "sys_name"
  end

  add_index "resources", ["sys_name"], :name => "index_resources_on_sys_name"

  create_table "roles", :force => true do |t|
    t.integer  "tenant_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["tenant_id"], :name => "index_roles_on_tenant_id"

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id", :null => false
    t.integer "user_id", :null => false
  end

  add_index "roles_users", ["role_id", "user_id"], :name => "index_roles_users_on_role_id_and_user_id", :unique => true

  create_table "subscriptions", :force => true do |t|
    t.integer  "plan_id"
    t.integer  "tenant_id"
    t.integer  "user_id"
    t.decimal  "price",                 :precision => 6, :scale => 2
    t.integer  "user_limit"
    t.integer  "machine_limit"
    t.integer  "payment_period"
    t.datetime "next_payment_date"
    t.string   "paypal_token"
    t.string   "paypal_customer_token"
    t.string   "paypal_payment_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscriptions", ["tenant_id"], :name => "index_subscriptions_on_tenant_id"

  create_table "tenants", :force => true do |t|
    t.string   "name"
    t.string   "subdomain"
    t.string   "cname"
    t.datetime "passive_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tenants", ["cname"], :name => "index_tenants_on_cname", :unique => true
  add_index "tenants", ["name"], :name => "index_tenants_on_name", :unique => true
  add_index "tenants", ["passive_at"], :name => "index_tenants_on_passive_at"
  add_index "tenants", ["subdomain"], :name => "index_tenants_on_subdomain", :unique => true

  create_table "users", :force => true do |t|
    t.integer  "tenant_id"
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "time_zone"
    t.string   "locale"
    t.boolean  "disabled",        :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["tenant_id"], :name => "index_users_on_tenant_id"

end
