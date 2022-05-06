require 'rails_helper'

RSpec.describe "supplier_invoices/index", type: :view do
  before(:each) do
    assign(:supplier_invoices, [
      SupplierInvoice.create!(
        number: "Number",
        value: "9.99",
        paid_amount: "Paid Amount",
        supplier: nil
      ),
      SupplierInvoice.create!(
        number: "Number",
        value: "9.99",
        paid_amount: "Paid Amount",
        supplier: nil
      )
    ])
  end

  it "renders a list of supplier_invoices" do
    render
    assert_select "tr>td", text: "Number".to_s, count: 2
    assert_select "tr>td", text: "9.99".to_s, count: 2
    assert_select "tr>td", text: "Paid Amount".to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
  end
end
