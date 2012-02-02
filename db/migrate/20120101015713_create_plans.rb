class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string  :name
      t.decimal :price, :precision => 6, :scale => 2
      t.integer :user_limit
      t.boolean :recommended, :default => false
    end
  end
end
