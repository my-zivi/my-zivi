# frozen_string_literal: true

json.extract! service, :id, :user_id, :beginning, :ending,
              :confirmation_date, :eligible_paid_vacation_days, :service_type, :first_swo_service,
              :long_service, :probation_service, :feedback_mail_sent
json.service_specification_identification_number service.service_specification.identification_number
