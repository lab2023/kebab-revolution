class CreatePrivileges < ActiveRecord::Migration
  def up
    create_table :privileges do |t|
      t.string :sys_name
    end

    Privilege.create_translation_table! :name => :string, :info => :text
  end

  def down
    Privilege.drop_translation_table!
    drop_table :privileges
  end
end
