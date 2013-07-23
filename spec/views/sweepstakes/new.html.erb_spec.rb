require 'spec_helper'

describe "sweepstakes/new" do
  before(:each) do
    assign(:sweepstake, stub_model(Sweepstake,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new sweepstake form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => sweepstakes_path, :method => "post" do
      assert_select "input#sweepstake_name", :name => "sweepstake[name]"
    end
  end
end
