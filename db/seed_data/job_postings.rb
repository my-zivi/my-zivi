# frozen_string_literal: true

JobPosting.without_auto_index do
  JobPosting.create!(JSON.parse(File.read(Rails.root.join('db/seed_data/job_postings.json'))))
end

puts '> Job postings seeded'
