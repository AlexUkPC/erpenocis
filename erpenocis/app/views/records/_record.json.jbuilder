json.extract! record, :id, :record_type, :location, :initial_data, :modified_data, :user_id, :created_at, :updated_at
json.url record_url(record, format: :json)
