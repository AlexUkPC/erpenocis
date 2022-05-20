# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_05_18_094518) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "cars", force: :cascade do |t|
    t.string "number_plate"
    t.date "rca_expiry_date"
    t.date "rov_expiry_date"
    t.date "itp_expiry_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "employee_salaries", force: :cascade do |t|
    t.decimal "net_salary", precision: 15, scale: 2, default: "0.0"
    t.decimal "salary_tax", precision: 15, scale: 2, default: "0.0"
    t.date "salary_tax_due_date"
    t.decimal "meal_vouchers", precision: 15, scale: 2, default: "0.0"
    t.decimal "gift_vouchers", precision: 15, scale: 2, default: "0.0"
    t.decimal "overtime", precision: 15, scale: 2, default: "0.0"
    t.decimal "extra_salary", precision: 15, scale: 2, default: "0.0"
    t.bigint "employee_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "date"
    t.index ["employee_id"], name: "index_employee_salaries_on_employee_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "name"
    t.date "hire_date"
    t.date "dismiss_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "expense_values", force: :cascade do |t|
    t.decimal "value", precision: 15, scale: 2
    t.date "date"
    t.date "due_date"
    t.boolean "vat_taxes"
    t.bigint "expense_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["expense_id"], name: "index_expense_values_on_expense_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.string "name"
    t.integer "expense_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.string "description"
    t.string "category"
    t.string "supplier"
    t.string "invoice_number"
    t.date "invoice_date"
    t.decimal "invoice_value_without_vat", precision: 15, scale: 2
    t.decimal "invoice_value_for_project_without_vat", precision: 15, scale: 2
    t.string "code"
    t.text "obs"
    t.bigint "project_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "user_id"
    t.index ["project_id"], name: "index_invoices_on_project_id"
  end

  create_table "january_solds", force: :cascade do |t|
    t.decimal "january_sold", precision: 15, scale: 2
    t.integer "year"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer "status"
    t.string "category"
    t.string "name_type_color"
    t.integer "needed_quantity"
    t.string "unit"
    t.string "cote"
    t.string "brother_id"
    t.integer "ordered_quantity", default: 0
    t.string "supplier_contact"
    t.date "order_date"
    t.date "delivery_date"
    t.text "obs"
    t.bigint "project_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "user_id"
    t.bigint "supplier_id"
    t.index ["project_id"], name: "index_orders_on_project_id"
    t.index ["supplier_id"], name: "index_orders_on_supplier_id"
  end

  create_table "project_costs", force: :cascade do |t|
    t.decimal "amount", precision: 15, scale: 2
    t.integer "month"
    t.integer "year"
    t.bigint "project_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_id"], name: "index_project_costs_on_project_id"
  end

  create_table "project_situations", force: :cascade do |t|
    t.date "advance_invoice_date"
    t.string "advance_invoice_number"
    t.date "advance_payment_date"
    t.decimal "advance_payment", precision: 15, scale: 2, default: "0.0"
    t.integer "advance_month"
    t.integer "advance_year"
    t.date "closure_invoice_date"
    t.string "closure_invoice_number"
    t.date "closure_payment_date"
    t.decimal "closure_payment", precision: 15, scale: 2, default: "0.0"
    t.integer "closure_month"
    t.integer "closure_year"
    t.bigint "project_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_id"], name: "index_project_situations_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.date "start_date"
    t.date "end_date"
    t.decimal "value", precision: 15, scale: 2
    t.text "obs"
    t.boolean "stoc"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "user_id"
  end

  create_table "records", force: :cascade do |t|
    t.string "record_type"
    t.string "location"
    t.string "initial_data"
    t.string "modified_data"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_records_on_user_id"
  end

  create_table "supplier_invoice_payments", force: :cascade do |t|
    t.decimal "paid_amount", precision: 15, scale: 2
    t.date "date"
    t.bigint "supplier_invoice_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["supplier_invoice_id"], name: "index_supplier_invoice_payments_on_supplier_invoice_id"
  end

  create_table "supplier_invoices", force: :cascade do |t|
    t.string "number"
    t.decimal "value", precision: 15, scale: 2
    t.date "date"
    t.date "due_date"
    t.bigint "supplier_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["supplier_id"], name: "index_supplier_invoices_on_supplier_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "username"
    t.integer "role"
    t.boolean "active", default: true
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "employee_salaries", "employees"
  add_foreign_key "expense_values", "expenses"
  add_foreign_key "invoices", "projects"
  add_foreign_key "orders", "projects"
  add_foreign_key "orders", "suppliers"
  add_foreign_key "project_costs", "projects"
  add_foreign_key "project_situations", "projects"
  add_foreign_key "records", "users"
  add_foreign_key "supplier_invoice_payments", "supplier_invoices"
  add_foreign_key "supplier_invoices", "suppliers"
end
