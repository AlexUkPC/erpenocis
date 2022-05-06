require 'rails_helper'

RSpec.describe "expense_values/show", type: :view do
  before(:each) do
    @expense_value = assign(:expense_value, ExpenseValue.create!(
      value: "9.99",
      vat_taxes: false,
      expense: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(//)
  end
end
