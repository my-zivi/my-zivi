# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_07_114941) do

  create_table "addresses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "street"
    t.integer "zip"
    t.string "city"
    t.string "primary_line"
    t.string "secondary_line"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "civil_servants", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.integer "zdp", null: false
    t.string "hometown", null: false
    t.datetime "birthday", null: false
    t.string "phone", null: false
    t.string "iban"
    t.string "health_insurance"
    t.bigint "address_id", null: false
    t.bigint "regional_center_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["address_id"], name: "index_civil_servants_on_address_id"
    t.index ["regional_center_id"], name: "index_civil_servants_on_regional_center_id"
    t.index ["user_id"], name: "index_civil_servants_on_user_id"
  end

  create_table "expense_sheets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.date "beginning", null: false
    t.date "ending", null: false
    t.bigint "civil_servant_id", null: false
    t.integer "work_days", null: false
    t.integer "unpaid_company_holiday_days", default: 0, null: false
    t.integer "paid_company_holiday_days", default: 0, null: false
    t.string "company_holiday_comment"
    t.integer "workfree_days", default: 0, null: false
    t.integer "sick_days", default: 0, null: false
    t.string "sick_comment"
    t.integer "paid_vacation_days", default: 0, null: false
    t.string "paid_vacation_comment"
    t.integer "unpaid_vacation_days", default: 0, null: false
    t.string "unpaid_vacation_comment"
    t.integer "driving_expenses", default: 0, null: false
    t.string "driving_expenses_comment"
    t.integer "extraordinary_expenses", default: 0, null: false
    t.string "extraordinary_expenses_comment"
    t.integer "clothing_expenses", default: 0, null: false
    t.string "clothing_expenses_comment"
    t.string "bank_account_number", null: false
    t.integer "state", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "payment_timestamp"
    t.index ["civil_servant_id"], name: "index_expense_sheets_on_civil_servant_id"
  end

  create_table "holidays", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.date "beginning", null: false
    t.date "ending", null: false
    t.integer "holiday_type", default: 1, null: false
    t.string "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "regional_centers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "address", null: false
    t.string "short_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "service_specifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "short_name", null: false
    t.integer "work_clothing_expenses", null: false
    t.integer "accommodation_expenses", null: false
    t.text "work_days_expenses", null: false
    t.text "paid_vacation_expenses", null: false
    t.text "first_day_expenses", null: false
    t.text "last_day_expenses", null: false
    t.string "location", default: "zh"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "identification_number", null: false
    t.index ["identification_number"], name: "index_service_specifications_on_identification_number", unique: true
  end

  create_table "services", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "civil_servant_id", null: false
    t.bigint "service_specification_id", null: false
    t.date "beginning", null: false
    t.date "ending", null: false
    t.date "confirmation_date"
    t.integer "service_type", default: 0, null: false
    t.boolean "first_swo_service", default: true, null: false
    t.boolean "long_service", default: false, null: false
    t.boolean "probation_service", default: false, null: false
    t.boolean "feedback_mail_sent", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["civil_servant_id"], name: "index_services_on_civil_servant_id"
    t.index ["service_specification_id"], name: "index_services_on_service_specification_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", null: false
    t.integer "zip", null: false
    t.integer "role", default: 2, null: false
    t.string "city", null: false
    t.text "work_experience"
    t.boolean "driving_licence_b", default: false, null: false
    t.boolean "driving_licence_be", default: false, null: false
    t.text "internal_note"
    t.boolean "chainsaw_workshop", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string "legacy_password"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "whitelisted_jwts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "jti", null: false
    t.string "aud"
    t.datetime "exp", null: false
    t.bigint "users_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_whitelisted_jwts_on_jti", unique: true
    t.index ["users_id"], name: "index_whitelisted_jwts_on_users_id"
  end

  add_foreign_key "expense_sheets", "users", column: "civil_servant_id"
  add_foreign_key "services", "service_specifications"
  add_foreign_key "services", "users", column: "civil_servant_id"
  add_foreign_key "whitelisted_jwts", "users", column: "users_id", on_delete: :cascade
end
