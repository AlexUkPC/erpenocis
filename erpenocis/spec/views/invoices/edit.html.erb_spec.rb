require 'rails_helper'

RSpec.describe "invoices/edit", type: :view do
  before(:each) do
    @invoice = assign(:invoice, Invoice.create!(
      description: "MyString",
      category: "MyString",
      supplier: "MyString",
      invoice_number: "MyString",
      invoice_value_without_vat: "9.99",
      invoice_value_for_project_without_vat: "9.99",
      code: "MyString",
      obs: "MyText",
      project: nil
    ))
  end

  it "renders the edit invoice form" do
    render

    assert_select "form[action=?][method=?]", invoice_path(@invoice), "post" do

      assert_select "input[name=?]", "invoice[description]"

      assert_select "input[name=?]", "invoice[category]"

      assert_select "input[name=?]", "invoice[supplier]"

      assert_select "input[name=?]", "invoice[invoice_number]"

      assert_select "input[name=?]", "invoice[invoice_value_without_vat]"

      assert_select "input[name=?]", "invoice[invoice_value_for_project_without_vat]"

      assert_select "input[name=?]", "invoice[code]"

      assert_select "textarea[name=?]", "invoice[obs]"

      assert_select "input[name=?]", "invoice[project_id]"
    end
  end
end
