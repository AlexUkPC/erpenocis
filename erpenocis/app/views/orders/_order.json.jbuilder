json.extract! order, :id, :status, :category, :name_type_color, :needed_quantity, :unit, :cote, :brother_id, :ordered_quantity, :supplier_id, :supplier_contact, :order_date, :delivery_date, :obs, :project_id, :created_at, :updated_at
json.url order_url(order, format: :json)
