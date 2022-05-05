require 'rails_helper'

RSpec.describe "project_costs/new", type: :view do
  before(:each) do
    assign(:project_cost, ProjectCost.new(
      amount: "9.99",
      month: 1,
      year: 1,
      project: nil
    ))
  end

  it "renders new project_cost form" do
    render

    assert_select "form[action=?][method=?]", project_costs_path, "post" do

      assert_select "input[name=?]", "project_cost[amount]"

      assert_select "input[name=?]", "project_cost[month]"

      assert_select "input[name=?]", "project_cost[year]"

      assert_select "input[name=?]", "project_cost[project_id]"
    end
  end
end
