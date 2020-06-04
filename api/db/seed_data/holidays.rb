# frozen_string_literal: true

holidays = JSON.parse(File.read(Rails.root.join('db/seed_data/holidays.json')), symbolize_names: true)

Holiday.create!(holidays)
