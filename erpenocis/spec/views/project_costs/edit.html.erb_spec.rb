require 'rails_helper'

RSpec.describe "project_costs/edit", type: :view do
  before(:each) do
    @project_cost = assign(:project_cost, ProjectCost.create!(
      amount: "9.99",
      month: 1,
      year: 1,
      project: nil
    ))
  end

  it "renders the edit project_cost form" do
    render

    assert_select "form[action=?][method=?]", project_cost_path(@project_cost), "post" do

      assert_select "input[name=?]", "project_cost[amount]"

      assert_select "input[name=?]", "project_cost[month]"

      assert_select "input[name=?]", "project_cost[year]"

      assert_select "input[name=?]", "project_cost[project_id]"
    end
  end
end
