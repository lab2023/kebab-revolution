require 'spec_helper'

describe Plan do
  before(:each) do
    @new_subscription_plan = Plan.new
  end

  it "can be instance of SubscriptionPlan" do
    @new_subscription_plan.should be_an_instance_of(Plan)
  end

  describe "name" do
    it "should be presence" do
      @new_subscription_plan.should be_invalid
      @new_subscription_plan.errors[:name].should include("can't be blank")
    end
  end

  describe "amount" do
    it "should be presence" do
      @new_subscription_plan.should be_invalid
      @new_subscription_plan.errors[:amount].should include("can't be blank")
    end

    it "should be greater or equal to zero" do
      @new_subscription_plan.amount = -1
      @new_subscription_plan.should be_invalid
      @new_subscription_plan.errors[:amount].should include("must be greater than or equal to 0")
    end

  end

  describe "user_limit" do
    it "should be presence" do
      @new_subscription_plan.should be_invalid
      @new_subscription_plan.errors[:user_limit].should include("can't be blank")
    end

    it "should be integer type" do
      @new_subscription_plan.should be_invalid
      @new_subscription_plan.errors[:user_limit].should include("is not a number")
    end

    it "should be greater than zero" do
      @new_subscription_plan.user_limit = -1
      @new_subscription_plan.should be_invalid
      @new_subscription_plan.errors[:user_limit].should include("must be greater than 0")
    end

  end

  describe "recommended" do
    it "should be recommended only one plan" do
      Plan.create(:name => 'basic', :amount => 100, :user_limit => 3, :recommended => true)
      @new_subscription_plan.recommended = 'true'
      @new_subscription_plan.should be_invalid
      @new_subscription_plan.errors[:recommended].should include("recommended plan is already choiced")
    end

  end

end
