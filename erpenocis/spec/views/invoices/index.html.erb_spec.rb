require 'rails_helper'

RSpec.describe "invoices/index", type: :view do
  before(:each) do
    assign(:invoices, [
      Invoice.create!(
        description: "Description",
        category: "Category",
        supplier: "Supplier",
        invoice_number: "Invoice Number",
        invoice_value_without_vat: "9.99",
        invoice_value_for_project_without_vat: "9.99",
        code: "Code",
        obs: "MyText",
        project: nil
      ),
      Invoice.create!(
        description: "Description",
        category: "Category",
        supplier: "Supplier",
        invoice_number: "Invoice Number",
        invoice_value_without_vat: "9.99",
        invoice_value_for_project_without_vat: "9.99",
        code: "Code",
        obs: "MyText",
        project: nil
      )
    ])
  end

  it "renders a list of invoices" do
    render
    assert_select "tr>td", text: "Description".to_s, count: 2
    assert_select "tr>td", text: "Category".to_s, count: 2
    assert_select "tr>td", text: "Supplier".to_s, count: 2
    assert_select "tr>td", text: "Invoice Number".to_s, count: 2
    assert_select "tr>td", text: "9.99".to_s, count: 2
    assert_select "tr>td", text: "9.99".to_s, count: 2
    assert_select "tr>td", text: "Code".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
  end
end
