# frozen_string_literal: true

JobPosting.create!(JSON.parse(File.read(Rails.root.join('db/seed_data/job_postings.json'))))

puts '> Job postings seeded'
