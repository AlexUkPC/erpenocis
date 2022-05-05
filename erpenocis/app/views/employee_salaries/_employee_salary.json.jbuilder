json.extract! employee_salary, :id, :net_salary, :salary_tax, :salary_tax_due_date, :meal_vouchers, :gift_vouchers, :overtime, :extra_salary, :month, :year, :employee_id, :created_at, :updated_at
json.url employee_salary_url(employee_salary, format: :json)
