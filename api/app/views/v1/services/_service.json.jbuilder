# frozen_string_literal: true

Jbuilder.key_format ->(key) { key.to_s.chomp('?') }

json.extract! service, :id, :user_id, :beginning, :ending,
              :confirmation_date, :eligible_paid_vacation_days, :service_type, :first_swo_service,
              :long_service, :probation_service, :service_days, :service_specification_id, :deletable?
json.service_specification do
  json.extract! service.service_specification, :identification_number, :name
end
