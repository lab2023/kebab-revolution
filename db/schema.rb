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

ActiveRecord::Schema.define(:version => 20111217164335) do

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

  create_table "tenants", :force => true do |t|
    t.string   "name"
    t.string   "host"
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
    t.boolean  "is_owner"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["tenant_id"], :name => "index_users_on_tenant_id"

end
