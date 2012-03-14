require 'spec_helper'

describe Resource do
  before(:each) do
    @resource = Factory(:resource)
    @new_resource = Resource.new
  end

  describe "sys_name" do
    it "should be presence" do
      @new_resource.should be_invalid
      @new_resource.errors[:sys_name].should include("can't be blank")
    end

    it "should be uniqueness" do
      @new_resource.sys_name = @resource.sys_name
      @new_resource.should be_invalid
      @new_resource.errors[:sys_name].should include("has already been taken")
    end
  end
end
