# frozen_string_literal: true

json.extract! service_specification, :id, :name, :short_name, :working_clothes_expenses,
              :accommodation_expenses, :work_days_expenses, :paid_vacation_expenses, :first_day_expenses,
              :last_day_expenses, :location, :active
