require 'spec_helper'

describe "LabelTemplates" do
  describe "GET /label_templates" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get label_templates_path
      response.status.should be(200)
    end
  end
end
