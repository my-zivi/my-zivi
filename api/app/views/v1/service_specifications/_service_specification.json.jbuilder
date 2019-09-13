# frozen_string_literal: true

json.extract!(service_specification,
              :id, :accommodation_expenses, :active,
              :first_day_expenses, :identification_number,
              :last_day_expenses, :location, :name,
              :paid_vacation_expenses, :short_name,
              :work_clothing_expenses, :work_days_expenses)
json.pocket_money ServiceSpecification::POCKET_MONEY
