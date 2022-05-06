require 'rails_helper'

RSpec.describe "expense_values/edit", type: :view do
  before(:each) do
    @expense_value = assign(:expense_value, ExpenseValue.create!(
      value: "9.99",
      vat_taxes: false,
      expense: nil
    ))
  end

  it "renders the edit expense_value form" do
    render

    assert_select "form[action=?][method=?]", expense_value_path(@expense_value), "post" do

      assert_select "input[name=?]", "expense_value[value]"

      assert_select "input[name=?]", "expense_value[vat_taxes]"

      assert_select "input[name=?]", "expense_value[expense_id]"
    end
  end
end
