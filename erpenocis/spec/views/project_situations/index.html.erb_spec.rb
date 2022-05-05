require 'rails_helper'

RSpec.describe "project_situations/index", type: :view do
  before(:each) do
    assign(:project_situations, [
      ProjectSituation.create!(
        advance_invoice_number: "Advance Invoice Number",
        advance_payment: "9.99",
        advance_month: 2,
        advance_year: 3,
        closure_invoice_number: "Closure Invoice Number",
        closure_payment: "9.99",
        closure_month: 4,
        closure_year: 5,
        project: nil
      ),
      ProjectSituation.create!(
        advance_invoice_number: "Advance Invoice Number",
        advance_payment: "9.99",
        advance_month: 2,
        advance_year: 3,
        closure_invoice_number: "Closure Invoice Number",
        closure_payment: "9.99",
        closure_month: 4,
        closure_year: 5,
        project: nil
      )
    ])
  end

  it "renders a list of project_situations" do
    render
    assert_select "tr>td", text: "Advance Invoice Number".to_s, count: 2
    assert_select "tr>td", text: "9.99".to_s, count: 2
    assert_select "tr>td", text: 2.to_s, count: 2
    assert_select "tr>td", text: 3.to_s, count: 2
    assert_select "tr>td", text: "Closure Invoice Number".to_s, count: 2
    assert_select "tr>td", text: "9.99".to_s, count: 2
    assert_select "tr>td", text: 4.to_s, count: 2
    assert_select "tr>td", text: 5.to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
  end
end
