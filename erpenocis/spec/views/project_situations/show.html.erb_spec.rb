require 'rails_helper'

RSpec.describe "project_situations/show", type: :view do
  before(:each) do
    @project_situation = assign(:project_situation, ProjectSituation.create!(
      advance_invoice_number: "Advance Invoice Number",
      advance_payment: "9.99",
      advance_month: 2,
      advance_year: 3,
      closure_invoice_number: "Closure Invoice Number",
      closure_payment: "9.99",
      closure_month: 4,
      closure_year: 5,
      project: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Advance Invoice Number/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Closure Invoice Number/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(//)
  end
end
