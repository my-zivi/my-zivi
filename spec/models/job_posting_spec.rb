# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobPosting, type: :model do
  subject(:model) { described_class.new }

  it_behaves_like 'validates presence of required fields', %i[
    link
    title
    publication_date
    description
    canton
    identification_number
    category
    sub_category
    language
    minimum_service_length
    contact_information
  ]

  it 'validates uniqueness of link and identification_number' do
    expect(model).to validate_uniqueness_of(:link)
    expect(model).to validate_uniqueness_of(:identification_number)
  end
end
