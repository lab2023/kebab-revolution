class CreatePlans < ActiveRecord::Migration
  def up
    create_table :plans do |t|
      t.string  :name
      t.decimal :price, :precision => 6, :scale => 2
      t.integer :user_limit
      t.boolean :recommended, :default => false
    end

    Plan.create!(:name => "Free",    :price => 0,   :user_limit => 2,    :recommended => false)
    Plan.create!(:name => "Basic",   :price => 99,  :user_limit => 4,    :recommended => false)
    Plan.create!(:name => "Plus",    :price => 299, :user_limit => 12,   :recommended => true)
    Plan.create!(:name => "Premium", :price => 499, :user_limit => 24,   :recommended => false)
    Plan.create!(:name => "Max",     :price => 999, :user_limit => 9999, :recommended => false)

  end

  def down
    drop_table :plans
  end
end
