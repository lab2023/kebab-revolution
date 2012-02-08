class CreatePrivileges < ActiveRecord::Migration
  def up
    create_table :privileges do |t|
      t.string :sys_name
    end

    Privilege.create_translation_table! :name => :string, :info => :text

    # add initial data    
    # English
    I18n.locale = :en
    invite_user  = Privilege.create!(sys_name: 'InviteUser',        name: 'Invite User')
    passive_user = Privilege.create!(sys_name: 'PassiveUser',       name: 'Passive User')
    active_user  = Privilege.create!(sys_name: 'ActiveUser',        name: 'Active User')
    manager_account = Privilege.create!(sys_name: 'ManageAccount',     name: 'Manage Account')

    # Turkish
    I18n.locale = :tr
    invite_user.name = "Kullanıcı Daveti"
    invite_user.save
    passive_user.name = "Kullanıcıyı Pasif Etme"
    passive_user.save
    active_user.name = "Kullanıcıyı Aktif Etme"
    active_user.save
    manager_account.name = "Hesap Yönetimi"
    manager_account.save

    # Russian
    I18n.locale = :ru
    invite_user.name = "Пригласить пользователей"
    invite_user.save
    passive_user.name = "Пассивный пользователя"
    passive_user.save
    active_user.name = "Активация пользователя"
    active_user.save
    manager_account.name = "Управление аккаунтом"
    manager_account.save
  end

  def down
    Privilege.drop_translation_table!
    drop_table :privileges
  end
end
