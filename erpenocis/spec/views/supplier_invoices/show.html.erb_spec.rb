require 'rails_helper'

RSpec.describe "supplier_invoices/show", type: :view do
  before(:each) do
    @supplier_invoice = assign(:supplier_invoice, SupplierInvoice.create!(
      number: "Number",
      value: "9.99",
      paid_amount: "Paid Amount",
      supplier: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Number/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/Paid Amount/)
    expect(rendered).to match(//)
  end
end
