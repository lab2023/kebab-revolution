class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.string :sys_name
      t.string :department
    end
  end
end
