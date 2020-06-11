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

ActiveRecord::Schema.define(version: 2020_06_11_110653) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "primary_line", null: false
    t.string "secondary_line"
    t.string "street", null: false
    t.string "city", null: false
    t.integer "zip", null: false
  end

  create_table "administrators", force: :cascade do |t|
    t.bigint "organizations_id", null: false
    t.index ["organizations_id"], name: "index_administrators_on_organizations_id"
  end

  create_table "civil_servants", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.integer "zdp", null: false
    t.string "hometown", null: false
    t.date "birthday", null: false
    t.string "phone", null: false
    t.string "iban", null: false
    t.string "health_insurance", null: false
    t.bigint "regional_centers_id", null: false
    t.bigint "addresses_id", null: false
    t.index ["addresses_id"], name: "index_civil_servants_on_addresses_id"
    t.index ["regional_centers_id"], name: "index_civil_servants_on_regional_centers_id"
    t.index ["zdp"], name: "index_civil_servants_on_zdp", unique: true
  end

  create_table "civil_servants_driving_licenses", id: false, force: :cascade do |t|
    t.bigint "civil_servant_id", null: false
    t.bigint "driving_license_id", null: false
    t.index ["civil_servant_id"], name: "index_civil_servants_driving_licenses_on_civil_servant_id"
    t.index ["driving_license_id"], name: "index_civil_servants_driving_licenses_on_driving_license_id"
  end

  create_table "civil_servants_workshops", id: false, force: :cascade do |t|
    t.bigint "civil_servant_id", null: false
    t.bigint "workshop_id", null: false
    t.index ["civil_servant_id"], name: "index_civil_servants_workshops_on_civil_servant_id"
    t.index ["workshop_id"], name: "index_civil_servants_workshops_on_workshop_id"
  end

  create_table "driving_licenses", force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_driving_licenses_on_name", unique: true
  end

  create_table "driving_licenses_service_specifications", id: false, force: :cascade do |t|
    t.bigint "driving_license_id", null: false
    t.bigint "service_specification_id", null: false
    t.boolean "mandatory", default: false, null: false
    t.index ["driving_license_id"], name: "index_driving_licenses_service_spec_on_driving_license_id"
    t.index ["service_specification_id"], name: "index_driving_licenses_service_spec_on_service_specification_id"
  end

  create_table "expense_sheets", force: :cascade do |t|
    t.date "beginning", null: false
    t.date "ending", null: false
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
    t.string "credited_iban", null: false
    t.integer "state", default: 0, null: false
    t.integer "amount", default: 0, null: false
    t.bigint "services_id", null: false
    t.bigint "payments_id"
    t.index ["payments_id"], name: "index_expense_sheets_on_payments_id"
    t.index ["services_id"], name: "index_expense_sheets_on_services_id"
  end

  create_table "organization_holidays", force: :cascade do |t|
    t.date "beginning", null: false
    t.date "ending", null: false
    t.string "description", null: false
    t.bigint "organizations_id", null: false
    t.index ["organizations_id"], name: "index_organization_holidays_on_organizations_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", null: false
    t.text "intro_text"
    t.bigint "address_id", null: false
    t.bigint "letter_address_id", null: false
    t.index ["address_id"], name: "index_organizations_on_address_id"
    t.index ["letter_address_id"], name: "index_organizations_on_letter_address_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "state", default: 0, null: false
    t.datetime "paid_timestamp"
    t.bigint "organization_id", null: false
    t.index ["organization_id"], name: "index_payments_on_organization_id"
  end

  create_table "regional_centers", force: :cascade do |t|
    t.string "name", null: false
    t.string "short_name", null: false
    t.bigint "addresses_id", null: false
    t.index ["addresses_id"], name: "index_regional_centers_on_addresses_id"
  end

  create_table "service_specifications", force: :cascade do |t|
    t.string "name", null: false
    t.string "short_name", null: false
    t.integer "work_clothing_expenses", null: false
    t.integer "accommodation_expenses", null: false
    t.json "work_days_expenses", null: false
    t.json "paid_vacation_expenses", null: false
    t.json "first_day_expenses", null: false
    t.json "last_day_expenses", null: false
    t.string "location"
    t.boolean "active", default: true
    t.string "identification_number", null: false
    t.bigint "organizations_id", null: false
    t.index ["identification_number"], name: "index_service_specifications_on_identification_number", unique: true
    t.index ["organizations_id"], name: "index_service_specifications_on_organizations_id"
  end

  create_table "service_specifications_workshops", id: false, force: :cascade do |t|
    t.bigint "workshop_id", null: false
    t.bigint "service_specification_id", null: false
    t.boolean "mandatory", default: false, null: false
    t.index ["service_specification_id"], name: "index_service_spec_workshops_on_service_spec_id"
    t.index ["workshop_id"], name: "index_service_spec_workshops_on_service_specification_id"
  end

  create_table "services", force: :cascade do |t|
    t.date "beginning", null: false
    t.date "ending", null: false
    t.date "confirmation_date"
    t.integer "service_type", default: 0, null: false
    t.boolean "last_service", default: false, null: false
    t.boolean "feedback_mail_sent", default: false, null: false
    t.bigint "civil_servants_id", null: false
    t.bigint "service_specifications_id", null: false
    t.index ["civil_servants_id"], name: "index_services_on_civil_servants_id"
    t.index ["service_specifications_id"], name: "index_services_on_service_specifications_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.bigint "referencee_id", null: false
    t.string "referencee_type", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["referencee_id", "referencee_type"], name: "index_users_on_referencee_id_and_referencee_type", unique: true
  end

  create_table "workshops", force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_workshops_on_name", unique: true
  end

  add_foreign_key "administrators", "organizations", column: "organizations_id"
  add_foreign_key "civil_servants", "addresses", column: "addresses_id"
  add_foreign_key "civil_servants", "regional_centers", column: "regional_centers_id"
  add_foreign_key "civil_servants_driving_licenses", "civil_servants"
  add_foreign_key "civil_servants_driving_licenses", "driving_licenses"
  add_foreign_key "civil_servants_workshops", "civil_servants"
  add_foreign_key "civil_servants_workshops", "workshops"
  add_foreign_key "driving_licenses_service_specifications", "driving_licenses"
  add_foreign_key "driving_licenses_service_specifications", "service_specifications"
  add_foreign_key "expense_sheets", "payments", column: "payments_id"
  add_foreign_key "expense_sheets", "services", column: "services_id"
  add_foreign_key "organization_holidays", "organizations", column: "organizations_id"
  add_foreign_key "payments", "organizations"
  add_foreign_key "regional_centers", "addresses", column: "addresses_id"
  add_foreign_key "service_specifications", "organizations", column: "organizations_id"
  add_foreign_key "service_specifications_workshops", "service_specifications"
  add_foreign_key "service_specifications_workshops", "workshops"
  add_foreign_key "services", "civil_servants", column: "civil_servants_id"
  add_foreign_key "services", "service_specifications", column: "service_specifications_id"
end
