require 'rails_helper'

RSpec.describe "expense_values/new", type: :view do
  before(:each) do
    assign(:expense_value, ExpenseValue.new(
      value: "9.99",
      vat_taxes: false,
      expense: nil
    ))
  end

  it "renders new expense_value form" do
    render

    assert_select "form[action=?][method=?]", expense_values_path, "post" do

      assert_select "input[name=?]", "expense_value[value]"

      assert_select "input[name=?]", "expense_value[vat_taxes]"

      assert_select "input[name=?]", "expense_value[expense_id]"
    end
  end
end
