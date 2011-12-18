class CreatePrivileges < ActiveRecord::Migration
  def up
    create_table :privileges do |t|
      t.string :sys_name

      t.timestamps
    end

    Privilege.create_translation_table! :name => :string, :info => :text

    # add foreign key and make role_id not null
    execute <<-SQL
      ALTER TABLE  `privilege_translations`
        ADD CONSTRAINT `fk_privileges_privilege_translations_id`
        FOREIGN KEY (  `privilege_id` ) REFERENCES  `privileges` ( `id` )
        ON DELETE RESTRICT ON UPDATE RESTRICT
    SQL

    # add role_id not null
    execute <<-SQL
      ALTER TABLE  `privilege_translations` CHANGE  `privilege_id`  `privilege_id` INT( 11 ) NOT NULL
    SQL
  end

  def down
    # drop foreign key role_id
    execute <<-SQL
      ALTER TABLE `privilege_translations` DROP FOREIGN KEY `fk_privileges_privilege_translations_id`
    SQL

    Privilege.drop_translation_table!
    drop_table :privileges
  end
end
