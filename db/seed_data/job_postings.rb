# frozen_string_literal: true

JobPosting.without_auto_index do
  import_data = Rails.root.join('db/seed_data/job_postings.json.erb').read
  parsed_data = ERB.new(import_data).result
  JobPosting.create!(JSON.parse(parsed_data))
end

puts '> Job postings seeded'
