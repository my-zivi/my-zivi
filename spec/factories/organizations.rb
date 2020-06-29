# frozen_string_literal: true

FactoryBot.define do
  factory :organization do
    name { 'MyZivi AG' }
    intro_text { 'This is the best zivi organization' }
    address
    creditor_detail
  end
end
