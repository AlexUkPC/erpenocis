require 'rails_helper'

RSpec.describe "invoices/show", type: :view do
  before(:each) do
    @invoice = assign(:invoice, Invoice.create!(
      description: "Description",
      category: "Category",
      supplier: "Supplier",
      invoice_number: "Invoice Number",
      invoice_value_without_vat: "9.99",
      invoice_value_for_project_without_vat: "9.99",
      code: "Code",
      obs: "MyText",
      project: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/Category/)
    expect(rendered).to match(/Supplier/)
    expect(rendered).to match(/Invoice Number/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/Code/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
  end
end
