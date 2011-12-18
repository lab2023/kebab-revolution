require 'spec_helper'

describe Service do
  before(:each) do
    @new_service = Service.new
  end

  it "should be instance of Service" do
    @new_service.should be_instance_of(Service)
  end

  it "references to Privilege" do
    @new_service.should be_invalid
    @new_service.errors[:privilege].should include("can't be blank")
  end

  describe "controller" do
    it "should be presence" do
      @new_service.should be_invalid
      @new_service.errors[:controller].should include("can't be blank")
    end
  end

  describe "action" do
    it "should be presence" do
      @new_service.should be_invalid
      @new_service.errors[:action].should include("can't be blank")
    end
  end
end
