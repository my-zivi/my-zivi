# frozen_string_literal: true

json.extract! user,
              :id, :address, :birthday, :chainsaw_workshop,
              :city, :driving_licence_b, :driving_licence_be, :email,
              :first_name, :health_insurance, :hometown, :internal_note,
              :last_name, :phone, :regional_center_id, :role, :work_experience, :zdp, :zip
json.bank_iban IBANTools::IBAN.new(user.bank_iban).prettify

json.services do
  json.array! user.services, partial: 'v1/services/service', as: :service
end

json.expense_sheets do
  json.array! user.expense_sheets, :id, :beginning, :ending, :duration, :state
end
