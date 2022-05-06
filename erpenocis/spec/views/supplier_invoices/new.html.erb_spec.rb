require 'rails_helper'

RSpec.describe "supplier_invoices/new", type: :view do
  before(:each) do
    assign(:supplier_invoice, SupplierInvoice.new(
      number: "MyString",
      value: "9.99",
      paid_amount: "MyString",
      supplier: nil
    ))
  end

  it "renders new supplier_invoice form" do
    render

    assert_select "form[action=?][method=?]", supplier_invoices_path, "post" do

      assert_select "input[name=?]", "supplier_invoice[number]"

      assert_select "input[name=?]", "supplier_invoice[value]"

      assert_select "input[name=?]", "supplier_invoice[paid_amount]"

      assert_select "input[name=?]", "supplier_invoice[supplier_id]"
    end
  end
end
