require 'spec_helper'

describe "label_templates/show" do
  before(:each) do
    @label_template = assign(:label_template, stub_model(LabelTemplate,
      :name => "Name",
      :group => "Group"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Group/)
  end
end
