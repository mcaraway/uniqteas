require 'spec_helper'

describe "sweepstakes/index" do
  before(:each) do
    assign(:sweepstakes, [
      stub_model(Sweepstake,
        :name => "Name"
      ),
      stub_model(Sweepstake,
        :name => "Name"
      )
    ])
  end

  it "renders a list of sweepstakes" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
