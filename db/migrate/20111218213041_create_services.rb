class CreateServices < ActiveRecord::Migration
  def up
    create_table :services do |t|
      t.references :privilege
      t.string :controller
      t.string :action
    end
    add_index :services, :privilege_id

    execute <<-SQL
      ALTER TABLE `services`
        ADD CONSTRAINT `fk_privileges_services`
        FOREIGN KEY ( `privilege_id` ) REFERENCES `privileges` ( `id` )
        ON DELETE RESTRICT ON UPDATE RESTRICT
    SQL

    execute <<-SQL
      ALTER TABLE `services` CHANGE `privilege_id` `privilege_id` INT ( 11 ) NOT NULL
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE `services`  DROP FOREIGN KEY fk_privileges_services
    SQL

    drop_table  :services
  end
end
