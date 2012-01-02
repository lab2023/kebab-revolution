class CreateApps < ActiveRecord::Migration
  def up
    create_table :apps do |t|
      t.string :sys_name
      t.string :sys_department
    end
  end

  def down
    drop_table :apps
  end
end
