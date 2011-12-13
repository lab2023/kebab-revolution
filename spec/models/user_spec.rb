require 'spec_helper'

describe User do  
  before(:each) do
    @user = Factory(:user)
    @new_user = User.new
  end
  
  it "can be instance of User" do
    @user.should be_an_instance_of(User)
  end
  
  it "references to Tenant" do
    @new_user.should be_invalid
    @new_user.errors[:tenant].should include("can't be blank")
  end
  
  describe "email" do
    it "should be presence" do
      @new_user.should be_invalid
      @new_user.errors[:email].should include("can't be blank")
    end
    
    it "should be uniqueness" do
      @new_user.email = @user.email
      @new_user.should be_invalid
      @new_user.errors[:email].should include("has already been taken")
    end
    
    it "should be email" do
      @new_user.email = 'invalid email'
      @new_user.should be_invalid
      @new_user.errors[:email].should include("is invalid")
    end   
    
  end
  
  describe "password" do
    it "should be presence" do
      @new_user.should be_invalid
      @new_user.errors[:password].should include("can't be blank")
    end
    
  end

  describe "password confirmation" do
    it "should be same value with password" do
      @new_user.password = 'password'
      @new_user.password_confirmation = 'diffrent_password'
      @new_user.should be_invalid
      @new_user.errors[:password].should include("doesn't match confirmation")
    end
  end

  describe "name" do
    it "should be presence" do
      @new_user.should be_invalid
      @new_user.errors[:name].should include("can't be blank")
    end    
  end
end