json.extract! supplier_invoice, :id, :number, :value, :paid_amount, :date, :due_date, :supplier_id, :created_at, :updated_at
json.url supplier_invoice_url(supplier_invoice, format: :json)
