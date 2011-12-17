require 'spec_helper'

describe Role do
  before(:each) do
    @new_role = Role.new
    @role = Role.create(:name => 'Admin')
  end

  it "can be instance of Role" do
    @new_role.should be_an_instance_of(Role)
  end

  it "references to Tenant" do
    @new_role.should be_invalid
    @new_role.errors[:tenant].should include("can't be blank")
  end

  describe "name" do
    it "should be presence" do
      @new_role.should be_invalid
      @new_role.errors[:name].should include("can't be blank")
    end

    it "fallbacks for empty translations" do
      @role.tenant = Tenant.create(:name => 'Test', :host => 'test.server-ror.local')
      I18n.locale = :tr
      @role.name.should eql('Admin')
    end
  end

end