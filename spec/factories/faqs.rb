# frozen_string_literal: true

FactoryBot.define do
  factory :faq do
    sequence(:question) { |i| "Question #{i}" }
    sequence(:answer) { |i| "Answer #{i}" }
  end
end
