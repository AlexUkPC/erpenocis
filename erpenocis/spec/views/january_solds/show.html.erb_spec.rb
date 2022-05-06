require 'rails_helper'

RSpec.describe "january_solds/show", type: :view do
  before(:each) do
    @january_sold = assign(:january_sold, JanuarySold.create!(
      january_sold: "9.99",
      year: 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/2/)
  end
end
