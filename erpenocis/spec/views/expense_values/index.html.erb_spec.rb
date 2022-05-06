require 'rails_helper'

RSpec.describe "expense_values/index", type: :view do
  before(:each) do
    assign(:expense_values, [
      ExpenseValue.create!(
        value: "9.99",
        vat_taxes: false,
        expense: nil
      ),
      ExpenseValue.create!(
        value: "9.99",
        vat_taxes: false,
        expense: nil
      )
    ])
  end

  it "renders a list of expense_values" do
    render
    assert_select "tr>td", text: "9.99".to_s, count: 2
    assert_select "tr>td", text: false.to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
  end
end
