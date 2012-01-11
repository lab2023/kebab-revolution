class CreateApplications < ActiveRecord::Migration
  def up
    create_table :applications do |t|
      t.string :sys_name
      t.string :sys_department
    end
  end

  def down
    drop_table :applications
  end
end
