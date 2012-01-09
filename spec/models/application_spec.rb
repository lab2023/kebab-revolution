require 'spec_helper'

describe Application do
  before(:each) do
    @new_app = Application.new
    @app = Application.create(:sys_name => 'aboutMe', :sys_department => 'system')
  end

  it "can be instance of App" do
    @new_app.should be_instance_of(Application)
  end

  describe "sys_name" do
    it "should be presence" do
      @new_app.should be_invalid
      @new_app.errors[:sys_name].should include("can't be blank")
    end

    it "should be uniqueness" do
      @new_app.sys_name = @app.sys_name
      @new_app.should be_invalid
      @new_app.errors[:sys_name].should include("has already been taken")
    end

  end

  describe "sys_department" do
    it "should be presence" do
      @new_app.should be_invalid
      @new_app.errors[:sys_department].should include("can't be blank")
    end
  end

  describe "name" do
    it "should be presence" do
      @new_app.should be_invalid
      @new_app.errors[:sys_name].should include("can't be blank")
    end
  end
end
