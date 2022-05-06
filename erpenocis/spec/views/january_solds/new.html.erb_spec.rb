require 'rails_helper'

RSpec.describe "january_solds/new", type: :view do
  before(:each) do
    assign(:january_sold, JanuarySold.new(
      january_sold: "9.99",
      year: 1
    ))
  end

  it "renders new january_sold form" do
    render

    assert_select "form[action=?][method=?]", january_solds_path, "post" do

      assert_select "input[name=?]", "january_sold[january_sold]"

      assert_select "input[name=?]", "january_sold[year]"
    end
  end
end
