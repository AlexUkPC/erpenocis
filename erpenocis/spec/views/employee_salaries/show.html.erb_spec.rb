require 'rails_helper'

RSpec.describe "employee_salaries/show", type: :view do
  before(:each) do
    @employee_salary = assign(:employee_salary, EmployeeSalary.create!(
      net_salary: "9.99",
      salary_tax: "9.99",
      meal_vouchers: "9.99",
      gift_vouchers: "9.99",
      overtime: "9.99",
      extra_salary: "9.99",
      month: 2,
      year: 3,
      employee: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(//)
  end
end
