require 'spec_helper'

describe "label_templates/edit" do
  before(:each) do
    @label_template = assign(:label_template, stub_model(LabelTemplate,
      :name => "MyString",
      :group => "MyString"
    ))
  end

  it "renders the edit label_template form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => label_templates_path(@label_template), :method => "post" do
      assert_select "input#label_template_name", :name => "label_template[name]"
      assert_select "input#label_template_group", :name => "label_template[group]"
    end
  end
end
