require 'rails_helper'

RSpec.describe "invoices/new", type: :view do
  before(:each) do
    assign(:invoice, Invoice.new(
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

  it "renders new invoice form" do
    render

    assert_select "form[action=?][method=?]", invoices_path, "post" do

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
