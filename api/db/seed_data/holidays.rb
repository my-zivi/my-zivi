holidays = JSON.parse(File.read(Rails.root.join('db', 'seed_data', 'holidays.json')), symbolize_names: true)

Holiday.create!(
  holidays.map do |holiday|
    holiday.merge(beginning: Date.parse(holiday[:beginning]), ending: Date.parse(holiday[:ending]))
  end
)
