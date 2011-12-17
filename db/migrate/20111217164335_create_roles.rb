class CreateRoles < ActiveRecord::Migration
  def up
    create_table :roles do |t|
      t.references :tenant

      t.timestamps
    end

    add_index :roles, :tenant_id

    Role.create_translation_table! :name => :string

    # add foreign key and make tenant_id not null
    execute <<-SQL
      ALTER TABLE  `roles`
        ADD CONSTRAINT fk_tenant_roles_id
        FOREIGN KEY (  `tenant_id` ) REFERENCES  `tenants` ( `id` )
        ON DELETE RESTRICT ON UPDATE RESTRICT
    SQL

    # add tenant_id not null
    execute <<-SQL
      ALTER TABLE  `roles` CHANGE  `tenant_id`  `tenant_id` INT( 11 ) NOT NULL
    SQL

    # add foreign key and make role_id not null
    execute <<-SQL
      ALTER TABLE  `role_translations`
        ADD CONSTRAINT fk_roles_role_translations_id
        FOREIGN KEY (  `role_id` ) REFERENCES  `roles` ( `id` )
        ON DELETE RESTRICT ON UPDATE RESTRICT
    SQL

    # add role_id not null
    execute <<-SQL
      ALTER TABLE  `role_translations` CHANGE  `role_id`  `role_id` INT( 11 ) NOT NULL
    SQL
  end

  def down

    # drop foreign key role_id
    execute <<-SQL
      ALTER TABLE `role_translations` DROP FOREIGN KEY fk_roles_role_translations_id
    SQL

    # drop foreign key tenant_id
    execute <<-SQL
      ALTER TABLE `roles` DROP FOREIGN KEY fk_tenant_roles_id
    SQL

    Role.drop_translation_table!
    drop_table :roles
  end
end
