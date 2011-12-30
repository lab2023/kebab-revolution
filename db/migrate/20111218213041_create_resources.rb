class CreateResources < ActiveRecord::Migration
  def up
    create_table :resources do |t|
      t.string :sys_path
      t.string :sys_name
    end
    add_index :resources, :sys_path
    add_index :resources, :sys_name
  end

  def down
    drop_table  :resources
  end
end
