require 'spec_helper'

describe Tenant do
  before(:each) do
    @tenant = Factory(:tenant)
    @new_tenant = Tenant.new
  end

  describe "Name" do
    it "should be presence" do
      @new_tenant.should be_invalid
      @new_tenant.errors[:name].should include("can't be blank")  
    end
    
    it "should be uniqueness" do
      @new_tenant.name = @tenant.name
      @new_tenant.should be_invalid
      @new_tenant.errors[:name].should include("has already been taken")
    end
    
    it "length should be minimum 4" do
      tenant = Tenant.create({:name => 'abc'})
      tenant.should be_invalid
      tenant.errors[:name].should include("is too short (minimum is 4 characters)")
    end
    
    it "length should be maximum 255" do
      tenant = Tenant.create({:name => 'test'*64})
      tenant.should be_invalid
      tenant.errors[:name].should include("is too long (maximum is 255 characters)")
    end    
  end
  
  describe "subdomain" do
    it "should be presence" do
      @new_tenant.should be_invalid
      @new_tenant.errors[:subdomain].should include("can't be blank")
    end
    
    it "should be uniqueness" do
      @new_tenant.subdomain = @tenant.host
      @new_tenant.should be_invalid
      @new_tenant.errors[:subdomain].should include("has already been taken")
    end
    
    it "should be exclusion of www" do
      @new_tenant.subdomain = 'www'
      @new_tenant.should be_invalid
      @new_tenant.errors[:subdomain].should include("is reserved")
    end
    
    it "length should be minimum 4" do
      tenant = Tenant.create({:subdomain => 'abc'})
      tenant.should be_invalid
      tenant.errors[:subdomain].should include("is too short (minimum is 4 characters)")
    end
    
    it "length should be maximum 255" do
      tenant = Tenant.create({:subdomain => 'test'*64})
      tenant.should be_invalid
      tenant.errors[:subdomain].should include("is too long (maximum is 255 characters)")
    end
  end
end