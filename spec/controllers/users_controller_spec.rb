require 'spec_helper'

describe UsersController do

  describe "GET 'update_profile'" do
    it "returns http success" do
      get 'update_profile'
      response.should be_success
    end
  end

end
