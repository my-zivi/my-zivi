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

ActiveRecord::Schema.define(version: 2020_10_14_185831) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "primary_line", null: false
    t.string "secondary_line"
    t.string "street", null: false
    t.string "supplement"
    t.string "city", null: false
    t.integer "zip", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "civil_servants", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.integer "zdp"
    t.string "hometown"
    t.date "birthday"
    t.string "phone"
    t.string "iban"
    t.string "health_insurance"
    t.bigint "address_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "regional_center"
    t.index ["address_id"], name: "index_civil_servants_on_address_id"
    t.index ["zdp"], name: "index_civil_servants_on_zdp", unique: true
  end

  create_table "civil_servants_driving_licenses", id: false, force: :cascade do |t|
    t.bigint "civil_servant_id", null: false
    t.bigint "driving_license_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["civil_servant_id"], name: "index_civil_servants_driving_licenses_on_civil_servant_id"
    t.index ["driving_license_id"], name: "index_civil_servants_driving_licenses_on_driving_license_id"
  end

  create_table "civil_servants_workshops", id: false, force: :cascade do |t|
    t.bigint "civil_servant_id", null: false
    t.bigint "workshop_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["civil_servant_id"], name: "index_civil_servants_workshops_on_civil_servant_id"
    t.index ["workshop_id"], name: "index_civil_servants_workshops_on_workshop_id"
  end

  create_table "creditor_details", force: :cascade do |t|
    t.string "bic"
    t.string "iban"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "driving_licenses", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_driving_licenses_on_name", unique: true
  end

  create_table "driving_licenses_service_specifications", id: false, force: :cascade do |t|
    t.bigint "driving_license_id", null: false
    t.bigint "service_specification_id", null: false
    t.boolean "mandatory", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.string "credited_iban"
    t.integer "state", default: 0, null: false
    t.integer "amount", default: 0, null: false
    t.bigint "service_id", null: false
    t.bigint "payment_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["payment_id"], name: "index_expense_sheets_on_payment_id"
    t.index ["service_id"], name: "index_expense_sheets_on_service_id"
  end

  create_table "mailing_lists", force: :cascade do |t|
    t.string "email", null: false
    t.string "name", null: false
    t.string "telephone", null: false
    t.string "organization", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_mailing_lists_on_email", unique: true
  end

  create_table "organization_holidays", force: :cascade do |t|
    t.date "beginning", null: false
    t.date "ending", null: false
    t.string "description", null: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["organization_id"], name: "index_organization_holidays_on_organization_id"
  end

  create_table "organization_members", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "phone", null: false
    t.string "organization_role", null: false
    t.string "contact_email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["contact_email"], name: "index_organization_members_on_contact_email", unique: true
    t.index ["organization_id"], name: "index_organization_members_on_organization_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", null: false
    t.text "intro_text"
    t.bigint "address_id", null: false
    t.bigint "letter_address_id"
    t.bigint "creditor_detail_id"
    t.string "identification_number", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["address_id"], name: "index_organizations_on_address_id"
    t.index ["creditor_detail_id"], name: "index_organizations_on_creditor_detail_id"
    t.index ["letter_address_id"], name: "index_organizations_on_letter_address_id"
  end

  create_table "payments", force: :cascade do |t|
    t.datetime "paid_timestamp"
    t.bigint "organization_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "amount", default: 0, null: false
    t.integer "state", default: 0, null: false
    t.integer "expense_sheets_count"
    t.index ["organization_id"], name: "index_payments_on_organization_id"
  end

  create_table "service_specifications", force: :cascade do |t|
    t.string "name", null: false
    t.string "internal_note"
    t.integer "work_clothing_expenses", null: false
    t.integer "accommodation_expenses", null: false
    t.jsonb "work_days_expenses", null: false
    t.jsonb "paid_vacation_expenses", null: false
    t.jsonb "first_day_expenses", null: false
    t.jsonb "last_day_expenses", null: false
    t.string "location"
    t.boolean "active", default: true
    t.string "identification_number", null: false
    t.bigint "organization_id", null: false
    t.bigint "contact_person_id", null: false
    t.bigint "lead_person_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["contact_person_id"], name: "index_service_specifications_on_contact_person_id"
    t.index ["identification_number"], name: "index_service_specifications_on_identification_number", unique: true
    t.index ["lead_person_id"], name: "index_service_specifications_on_lead_person_id"
    t.index ["organization_id"], name: "index_service_specifications_on_organization_id"
  end

  create_table "service_specifications_workshops", id: false, force: :cascade do |t|
    t.bigint "workshop_id", null: false
    t.bigint "service_specification_id", null: false
    t.boolean "mandatory", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.bigint "civil_servant_id", null: false
    t.bigint "service_specification_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "civil_servant_agreed", default: false, null: false
    t.datetime "civil_servant_agreed_on"
    t.boolean "organization_agreed", default: false, null: false
    t.datetime "organization_agreed_on"
    t.index ["civil_servant_id"], name: "index_services_on_civil_servant_id"
    t.index ["service_specification_id"], name: "index_services_on_service_specification_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.bigint "referencee_id"
    t.string "referencee_type"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "language", default: "de", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["referencee_id", "referencee_type"], name: "index_users_on_referencee_id_and_referencee_type", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "workshops", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_workshops_on_name", unique: true
  end

  add_foreign_key "civil_servants", "addresses"
  add_foreign_key "civil_servants_driving_licenses", "civil_servants"
  add_foreign_key "civil_servants_driving_licenses", "driving_licenses"
  add_foreign_key "civil_servants_workshops", "civil_servants"
  add_foreign_key "civil_servants_workshops", "workshops"
  add_foreign_key "driving_licenses_service_specifications", "driving_licenses"
  add_foreign_key "driving_licenses_service_specifications", "service_specifications"
  add_foreign_key "expense_sheets", "payments"
  add_foreign_key "expense_sheets", "services"
  add_foreign_key "organization_holidays", "organizations"
  add_foreign_key "organization_members", "organizations"
  add_foreign_key "organizations", "creditor_details"
  add_foreign_key "payments", "organizations"
  add_foreign_key "service_specifications", "organization_members", column: "contact_person_id"
  add_foreign_key "service_specifications", "organization_members", column: "lead_person_id"
  add_foreign_key "service_specifications", "organizations"
  add_foreign_key "service_specifications_workshops", "service_specifications"
  add_foreign_key "service_specifications_workshops", "workshops"
  add_foreign_key "services", "civil_servants"
  add_foreign_key "services", "service_specifications"
end
