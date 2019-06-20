# frozen_string_literal: true

json.extract! service, :id, :user_id, :service_specification_id, :beginning, :ending,
              :confirmation_date, :eligible_personal_vacation_days, :service_type, :first_swo_service,
              :long_service, :probation_service, :feedback_mail_sent
