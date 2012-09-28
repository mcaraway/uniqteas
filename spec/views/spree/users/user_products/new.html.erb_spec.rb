require 'spec_helper'

describe "user_products/new" do
  before(:each) do
    assign(:user_product, stub_model(UserProduct,
      :user_id => 1,
      :product_id => 1
    ).as_new_record)
  end

  it "renders new user_product form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => user_products_path, :method => "post" do
      assert_select "input#user_product_user_id", :name => "user_product[user_id]"
      assert_select "input#user_product_product_id", :name => "user_product[product_id]"
    end
  end
end
