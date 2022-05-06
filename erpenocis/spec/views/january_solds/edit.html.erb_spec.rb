require 'rails_helper'

RSpec.describe "january_solds/edit", type: :view do
  before(:each) do
    @january_sold = assign(:january_sold, JanuarySold.create!(
      january_sold: "9.99",
      year: 1
    ))
  end

  it "renders the edit january_sold form" do
    render

    assert_select "form[action=?][method=?]", january_sold_path(@january_sold), "post" do

      assert_select "input[name=?]", "january_sold[january_sold]"

      assert_select "input[name=?]", "january_sold[year]"
    end
  end
end
