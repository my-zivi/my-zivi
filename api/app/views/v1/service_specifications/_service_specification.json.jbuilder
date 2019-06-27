# frozen_string_literal: true

json.extract!(service_specification,
              :accommodation_expenses, :active,
              :first_day_expenses, :id, :identification_number,
              :last_day_expenses, :location, :name,
              :paid_vacation_expenses, :short_name,
              :work_clothing_expenses, :work_days_expenses)
