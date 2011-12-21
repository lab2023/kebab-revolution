class CreateApps < ActiveRecord::Migration
  def up

    create_table :apps do |t|
      t.string :sys_name
      t.string :sys_department
    end

    App.create_translation_table! :name => :string

    # add foreign key and make role_id not null
    execute <<-SQL
      ALTER TABLE  `app_translations`
        ADD CONSTRAINT fk_apps_app_translations_id
        FOREIGN KEY (  `app_id` ) REFERENCES  `apps` ( `id` )
        ON DELETE RESTRICT ON UPDATE RESTRICT
    SQL

    # add role_id not null
    execute <<-SQL
      ALTER TABLE  `app_translations` CHANGE  `app_id`  `app_id` INT( 11 ) NOT NULL
    SQL

  end

  def down
    # drop foreign key role_id
    execute <<-SQL
      ALTER TABLE `app_translations` DROP FOREIGN KEY fk_apps_app_translations_id
    SQL

    App.drop_translation_table!
    drop_table :apps
  end
end
