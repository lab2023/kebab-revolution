class CreatePrivileges < ActiveRecord::Migration
  def up
    create_table :privileges do |t|
      t.string :sys_name
    end

    Privilege.create_translation_table! :name => :string, :info => :text

    # add initial data
    Privilege.create!(sys_name: 'InviteUser',        name: 'Invite User')
    Privilege.create!(sys_name: 'PassiveUser',       name: 'Passive User')
    Privilege.create!(sys_name: 'ActiveUser',        name: 'Active User')
    Privilege.create!(sys_name: 'ManageAccount',     name: 'Manage Account')
  end

  def down
    Privilege.drop_translation_table!
    drop_table :privileges
  end
end
