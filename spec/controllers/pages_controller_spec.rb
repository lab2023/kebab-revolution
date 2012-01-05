require 'spec_helper'

describe PagesController do

  describe "GET 'desktop'" do
    it "returns http success" do
      get 'desktop'
      response.should be_success
    end
  end

  describe "GET 'login'" do
    it "returns http success" do
      get 'login'
      response.should be_success
    end
  end

  describe "GET 'plan'" do
    it "returns http success" do
      get 'plan'
      response.should be_success
    end
  end

end
