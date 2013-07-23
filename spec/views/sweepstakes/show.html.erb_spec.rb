require 'spec_helper'

describe "sweepstakes/show" do
  before(:each) do
    @sweepstake = assign(:sweepstake, stub_model(Sweepstake,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
