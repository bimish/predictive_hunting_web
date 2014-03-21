require 'spec_helper'

describe MapController do

  describe "GET 'hunting_plot'" do
    it "returns http success" do
      get 'hunting_plot'
      response.should be_success
    end
  end

end
