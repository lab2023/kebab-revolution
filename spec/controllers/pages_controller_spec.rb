require 'spec_helper'

describe PagesController do

  describe "GET 'desktop'" do
    it "returns http success" do
      get 'desktop'
      response.should be_success
    end
  end

  describe "GET 'login'" do
    it "returns http success"
  end

  describe "GET 'plans'" do
    it "returns http success" do
      get 'plans'
      response.should be_success
    end
  end

  describe "GET 'register'" do
    it "returns http success" do
      get 'register'
      response.should be_success
    end
  end

end
