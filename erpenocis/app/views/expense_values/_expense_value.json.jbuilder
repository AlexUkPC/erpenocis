json.extract! expense_value, :id, :value, :date, :due_date, :vat_taxes, :expense_id, :created_at, :updated_at
json.url expense_value_url(expense_value, format: :json)
