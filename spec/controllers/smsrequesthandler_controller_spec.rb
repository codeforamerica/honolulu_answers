require 'spec_helper'

describe SmsrequesthandlerController do

  describe "GET 'smshandler'" do
    it "returns http success" do
      get 'smshandler'
      response.should be_success
    end
  end

end
