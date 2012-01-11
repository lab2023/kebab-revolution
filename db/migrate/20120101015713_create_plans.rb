class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string  :name
      t.decimal :price
      t.integer :user_limit
      t.boolean :recommended, :default => false
    end
  end
end
