require 'rails_helper'

RSpec.describe "employee_salaries/index", type: :view do
  before(:each) do
    assign(:employee_salaries, [
      EmployeeSalary.create!(
        net_salary: "9.99",
        salary_tax: "9.99",
        meal_vouchers: "9.99",
        gift_vouchers: "9.99",
        overtime: "9.99",
        extra_salary: "9.99",
        month: 2,
        year: 3,
        employee: nil
      ),
      EmployeeSalary.create!(
        net_salary: "9.99",
        salary_tax: "9.99",
        meal_vouchers: "9.99",
        gift_vouchers: "9.99",
        overtime: "9.99",
        extra_salary: "9.99",
        month: 2,
        year: 3,
        employee: nil
      )
    ])
  end

  it "renders a list of employee_salaries" do
    render
    assert_select "tr>td", text: "9.99".to_s, count: 2
    assert_select "tr>td", text: "9.99".to_s, count: 2
    assert_select "tr>td", text: "9.99".to_s, count: 2
    assert_select "tr>td", text: "9.99".to_s, count: 2
    assert_select "tr>td", text: "9.99".to_s, count: 2
    assert_select "tr>td", text: "9.99".to_s, count: 2
    assert_select "tr>td", text: 2.to_s, count: 2
    assert_select "tr>td", text: 3.to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
  end
end
