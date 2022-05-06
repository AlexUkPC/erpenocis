require 'rails_helper'

RSpec.describe "supplier_invoices/edit", type: :view do
  before(:each) do
    @supplier_invoice = assign(:supplier_invoice, SupplierInvoice.create!(
      number: "MyString",
      value: "9.99",
      paid_amount: "MyString",
      supplier: nil
    ))
  end

  it "renders the edit supplier_invoice form" do
    render

    assert_select "form[action=?][method=?]", supplier_invoice_path(@supplier_invoice), "post" do

      assert_select "input[name=?]", "supplier_invoice[number]"

      assert_select "input[name=?]", "supplier_invoice[value]"

      assert_select "input[name=?]", "supplier_invoice[paid_amount]"

      assert_select "input[name=?]", "supplier_invoice[supplier_id]"
    end
  end
end
