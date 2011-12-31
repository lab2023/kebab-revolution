class CreateApps < ActiveRecord::Migration
  def up

    create_table :apps do |t|
      t.string :sys_name
      t.string :sys_department
    end

    # add role_id not null
    execute <<-SQL
      ALTER TABLE  `app_translations` CHANGE  `app_id`  `app_id` INT( 11 ) NOT NULL
    SQL

  end

  def down
    drop_table :apps
  end
end
