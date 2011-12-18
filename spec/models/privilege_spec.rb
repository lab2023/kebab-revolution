require 'spec_helper'

describe Privilege do
  before(:each) do
    @new_privilege = Privilege.new
    @privilege = Privilege.create(:sys_name => 'addNewUser', :name => 'Add a new user', :info => 'Can add a new user. After that it send email. etc')
  end

  it "can be instance of Privilege" do
    @new_privilege.should be_an_instance_of(Privilege)
  end

  describe "sys_name" do
    it "should be presence" do
      @new_privilege.should be_invalid
      @new_privilege.errors[:sys_name].should include("can't be blank")
    end

    it "should be unique" do
      @new_privilege.sys_name = @privilege.sys_name
      @new_privilege.should be_invalid
      @new_privilege.errors[:sys_name].should include("has already been taken")
    end
  end

  describe "name" do
    it "should be presence" do
      @new_privilege.should be_invalid
      @new_privilege.errors[:name].should include("can't be blank")
    end

    it "fallbacks for empty translations" do
      I18n.locale = :tr
      @privilege.name.should eql(@privilege.name)
      I18n.locale = :en
    end
  end
end
