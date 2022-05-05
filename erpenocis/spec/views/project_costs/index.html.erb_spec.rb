require 'rails_helper'

RSpec.describe "project_costs/index", type: :view do
  before(:each) do
    assign(:project_costs, [
      ProjectCost.create!(
        amount: "9.99",
        month: 2,
        year: 3,
        project: nil
      ),
      ProjectCost.create!(
        amount: "9.99",
        month: 2,
        year: 3,
        project: nil
      )
    ])
  end

  it "renders a list of project_costs" do
    render
    assert_select "tr>td", text: "9.99".to_s, count: 2
    assert_select "tr>td", text: 2.to_s, count: 2
    assert_select "tr>td", text: 3.to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
  end
end
