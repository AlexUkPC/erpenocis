require 'rails_helper'

RSpec.describe "employee_salaries/edit", type: :view do
  before(:each) do
    @employee_salary = assign(:employee_salary, EmployeeSalary.create!(
      net_salary: "9.99",
      salary_tax: "9.99",
      meal_vouchers: "9.99",
      gift_vouchers: "9.99",
      overtime: "9.99",
      extra_salary: "9.99",
      month: 1,
      year: 1,
      employee: nil
    ))
  end

  it "renders the edit employee_salary form" do
    render

    assert_select "form[action=?][method=?]", employee_salary_path(@employee_salary), "post" do

      assert_select "input[name=?]", "employee_salary[net_salary]"

      assert_select "input[name=?]", "employee_salary[salary_tax]"

      assert_select "input[name=?]", "employee_salary[meal_vouchers]"

      assert_select "input[name=?]", "employee_salary[gift_vouchers]"

      assert_select "input[name=?]", "employee_salary[overtime]"

      assert_select "input[name=?]", "employee_salary[extra_salary]"

      assert_select "input[name=?]", "employee_salary[month]"

      assert_select "input[name=?]", "employee_salary[year]"

      assert_select "input[name=?]", "employee_salary[employee_id]"
    end
  end
end
