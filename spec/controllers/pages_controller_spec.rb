require 'spec_helper'

describe PagesController do

  describe "GET 'bighoop'" do
    it "returns http success" do
      get 'bighoop'
      response.should be_success
    end
  end

  describe "GET 'contact'" do
    it "returns http success" do
      get 'contact'
      response.should be_success
    end
  end

  describe "GET 'about'" do
    it "returns http success" do
      get 'about'
      response.should be_success
    end
  end

end
