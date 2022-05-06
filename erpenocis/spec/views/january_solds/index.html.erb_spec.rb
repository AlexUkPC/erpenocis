require 'rails_helper'

RSpec.describe "january_solds/index", type: :view do
  before(:each) do
    assign(:january_solds, [
      JanuarySold.create!(
        january_sold: "9.99",
        year: 2
      ),
      JanuarySold.create!(
        january_sold: "9.99",
        year: 2
      )
    ])
  end

  it "renders a list of january_solds" do
    render
    assert_select "tr>td", text: "9.99".to_s, count: 2
    assert_select "tr>td", text: 2.to_s, count: 2
  end
end
