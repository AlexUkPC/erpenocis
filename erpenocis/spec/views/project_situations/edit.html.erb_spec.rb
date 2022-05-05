require 'rails_helper'

RSpec.describe "project_situations/edit", type: :view do
  before(:each) do
    @project_situation = assign(:project_situation, ProjectSituation.create!(
      advance_invoice_number: "MyString",
      advance_payment: "9.99",
      advance_month: 1,
      advance_year: 1,
      closure_invoice_number: "MyString",
      closure_payment: "9.99",
      closure_month: 1,
      closure_year: 1,
      project: nil
    ))
  end

  it "renders the edit project_situation form" do
    render

    assert_select "form[action=?][method=?]", project_situation_path(@project_situation), "post" do

      assert_select "input[name=?]", "project_situation[advance_invoice_number]"

      assert_select "input[name=?]", "project_situation[advance_payment]"

      assert_select "input[name=?]", "project_situation[advance_month]"

      assert_select "input[name=?]", "project_situation[advance_year]"

      assert_select "input[name=?]", "project_situation[closure_invoice_number]"

      assert_select "input[name=?]", "project_situation[closure_payment]"

      assert_select "input[name=?]", "project_situation[closure_month]"

      assert_select "input[name=?]", "project_situation[closure_year]"

      assert_select "input[name=?]", "project_situation[project_id]"
    end
  end
end
