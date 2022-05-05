json.extract! invoice, :id, :description, :category, :supplier, :invoice_number, :invoice_date, :invoice_value_without_vat, :invoice_value_for_project_without_vat, :code, :obs, :project_id, :created_at, :updated_at
json.url invoice_url(invoice, format: :json)
