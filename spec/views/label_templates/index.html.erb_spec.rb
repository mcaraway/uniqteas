require 'spec_helper'

describe "label_templates/index" do
  before(:each) do
    assign(:label_templates, [
      stub_model(LabelTemplate,
        :name => "Name",
        :group => "Group"
      ),
      stub_model(LabelTemplate,
        :name => "Name",
        :group => "Group"
      )
    ])
  end

  it "renders a list of label_templates" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Group".to_s, :count => 2
  end
end
