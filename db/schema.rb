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

ActiveRecord::Schema.define(:version => 20111218213041) do

  create_table "apps", :force => true do |t|
    t.string "sys_name"
    t.string "department"
  end

  create_table "apps_privileges", :id => false, :force => true do |t|
    t.integer "app_id",       :null => false
    t.integer "privilege_id", :null => false
  end

  add_index "apps_privileges", ["app_id", "privilege_id"], :name => "index_apps_privileges_on_app_id_and_privilege_id", :unique => true
  add_index "apps_privileges", ["privilege_id"], :name => "fk_privileges_apps_privileges"

  create_table "privilege_translations", :force => true do |t|
    t.integer  "privilege_id", :null => false
    t.string   "locale"
    t.string   "name"
    t.text     "info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "privilege_translations", ["privilege_id"], :name => "index_privilege_translations_on_privilege_id"

  create_table "privileges", :force => true do |t|
    t.string   "sys_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "privileges_roles", :id => false, :force => true do |t|
    t.integer "privilege_id", :null => false
    t.integer "role_id",      :null => false
  end

  add_index "privileges_roles", ["privilege_id", "role_id"], :name => "index_privileges_roles_on_privilege_id_and_role_id", :unique => true
  add_index "privileges_roles", ["role_id"], :name => "fk_roles_privileges_roles_id"

  create_table "role_translations", :force => true do |t|
    t.integer  "role_id",    :null => false
    t.string   "locale"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "role_translations", ["role_id"], :name => "index_role_translations_on_role_id"

  create_table "roles", :force => true do |t|
    t.integer  "tenant_id",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["tenant_id"], :name => "index_roles_on_tenant_id"

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id", :null => false
    t.integer "user_id", :null => false
  end

  add_index "roles_users", ["role_id", "user_id"], :name => "index_roles_users_on_role_id_and_user_id", :unique => true
  add_index "roles_users", ["user_id"], :name => "fk_users_roles_users_id"

  create_table "services", :force => true do |t|
    t.integer "privilege_id", :null => false
    t.string  "controller"
    t.string  "action"
  end

  add_index "services", ["privilege_id"], :name => "index_services_on_privilege_id"

  create_table "tenants", :force => true do |t|
    t.string   "name"
    t.string   "host"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tenants", ["host"], :name => "index_tenants_on_host", :unique => true
  add_index "tenants", ["name"], :name => "index_tenants_on_name", :unique => true

  create_table "users", :force => true do |t|
    t.integer  "tenant_id",       :null => false
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["tenant_id"], :name => "index_users_on_tenant_id"

end
