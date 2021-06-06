# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobPosting, type: :model do
  subject(:model) { build(:job_posting) }

  it_behaves_like 'validates presence of required fields', %i[
    title
    publication_date
    description
    canton
    identification_number
    category
    language
    minimum_service_months
    contact_information
    organization_name
  ]

  context 'when an organization is referenced' do
    subject(:model) { build(:job_posting, organization_id: 1) }

    it { is_expected.not_to validate_presence_of :organization_name }
  end

  it 'validates uniqueness of identification_number' do
    expect(model).to validate_uniqueness_of(:identification_number)
  end

  describe 'relations' do
    it { is_expected.to have_many(:workshops).through(:job_posting_workshops) }
  end
end
