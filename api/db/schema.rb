# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_05_07_093510) do

  create_table "expense_sheets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.date "beginning", null: false
    t.date "ending", null: false
    t.bigint "user_id", null: false
    t.integer "work_days", null: false
    t.integer "company_holiday_unpaid_days", default: 0
    t.integer "company_holiday_paid_days", default: 0
    t.string "company_holiday_comment"
    t.integer "workfree_days", default: 0
    t.integer "ill_days", default: 0
    t.string "ill_comment"
    t.integer "personal_vacation_days", default: 0
    t.integer "paid_vacation_days", default: 0
    t.string "paid_vacation_comment"
    t.integer "unpaid_vacation_days", default: 0
    t.string "unpaid_vacation_comment"
    t.integer "driving_charges", default: 0
    t.string "driving_charges_comment"
    t.integer "extraordinarily_expenses", default: 0
    t.string "extraordinarily_expenses_comment"
    t.integer "clothes_expenses", default: 0
    t.string "clothes_expenses_comment"
    t.string "bank_account_number", null: false
    t.integer "state", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_expense_sheets_on_user_id"
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
    t.string "name"
    t.string "address"
    t.string "short_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "service_specifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "short_name", null: false
    t.integer "working_clothes_expenses", null: false
    t.integer "accommodation_expenses", null: false
    t.json "work_days_expenses", null: false
    t.json "paid_vacation_expense", null: false
    t.json "first_day_expense", null: false
    t.json "last_day_expense", null: false
    t.string "location", default: "zh"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "services", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "service_specification_id", null: false
    t.date "beginning", null: false
    t.date "ending", null: false
    t.date "confirmation_date"
    t.integer "eligible_personal_vacation_days", null: false
    t.integer "service_type", default: 0, null: false
    t.boolean "first_swo_service", null: false
    t.boolean "long_service", null: false
    t.boolean "probation_service", null: false
    t.boolean "feedback_mail_sent", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_specification_id"], name: "index_services_on_service_specification_id"
    t.index ["user_id"], name: "index_services_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", null: false
    t.integer "zdp", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "address", null: false
    t.integer "zip", null: false
    t.integer "role", default: 2, null: false
    t.string "city", null: false
    t.string "hometown", null: false
    t.date "birthday", null: false
    t.string "phone", null: false
    t.string "bank_iban", null: false
    t.string "health_insurance", null: false
    t.text "work_experience"
    t.boolean "driving_licence_b", default: false, null: false
    t.boolean "driving_licence_be", default: false, null: false
    t.bigint "regional_center_id"
    t.text "internal_note"
    t.boolean "chainsaw_workshop", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["regional_center_id"], name: "index_users_on_regional_center_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "whitelisted_jwts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "jti", null: false
    t.string "aud"
    t.datetime "exp", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_whitelisted_jwts_on_jti", unique: true
    t.index ["user_id"], name: "index_whitelisted_jwts_on_user_id"
  end

  add_foreign_key "expense_sheets", "users"
  add_foreign_key "services", "service_specifications"
  add_foreign_key "services", "users"
  add_foreign_key "users", "regional_centers"
  add_foreign_key "whitelisted_jwts", "users", on_delete: :cascade
end
