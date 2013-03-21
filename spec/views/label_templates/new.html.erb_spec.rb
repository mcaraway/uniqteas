require 'spec_helper'

describe "label_templates/new" do
  before(:each) do
    assign(:label_template, stub_model(LabelTemplate,
      :name => "MyString",
      :group => "MyString"
    ).as_new_record)
  end

  it "renders new label_template form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => label_templates_path, :method => "post" do
      assert_select "input#label_template_name", :name => "label_template[name]"
      assert_select "input#label_template_group", :name => "label_template[group]"
    end
  end
end
