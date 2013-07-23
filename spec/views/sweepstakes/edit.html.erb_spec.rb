require 'spec_helper'

describe "sweepstakes/edit" do
  before(:each) do
    @sweepstake = assign(:sweepstake, stub_model(Sweepstake,
      :name => "MyString"
    ))
  end

  it "renders the edit sweepstake form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => sweepstakes_path(@sweepstake), :method => "post" do
      assert_select "input#sweepstake_name", :name => "sweepstake[name]"
    end
  end
end
