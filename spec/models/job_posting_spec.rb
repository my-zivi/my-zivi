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
    brief_description
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

  describe '#plain_description' do
    subject { job_posting.plain_description }

    let(:job_posting) { build(:job_posting, description: '<p>Hello  </p>') }

    it { is_expected.to eq 'Hello' }
  end

  describe '#organization_display_name' do
    subject { job_posting.organization_display_name }

    let(:job_posting) { build(:job_posting, organization_name: 'MyOrg') }

    it { is_expected.to eq 'MyOrg' }

    context 'when job posting has an organization assigned' do
      let(:job_posting) { build(:job_posting, :claimed_by_organization) }

      it { is_expected.to eq job_posting.organization.name }
    end
  end

  describe '#category_display_name' do
    subject(:job_posting) { build(:job_posting) }

    it 'returns correct display names' do
      expect(job_posting.category_display_name).to eq(
        I18n.t('activerecord.enums.job_postings.category_abbreviation.nature_conservancy')
      )

      expect(job_posting.full_category_display_name).to eq(
        I18n.t('activerecord.enums.job_postings.category.nature_conservancy')
      )
    end
  end

  describe '#sub_category_display_name' do
    subject { build(:job_posting).sub_category_display_name }

    it { is_expected.to eq I18n.t('activerecord.enums.job_postings.sub_category.landscaping_and_gardening') }

    context 'when sub_category is nil' do
      subject { build(:job_posting, sub_category: nil).sub_category_display_name }

      it { is_expected.to be_nil }
    end
  end

  describe '#scraped?' do
    subject { build(:job_posting) }

    it { is_expected.to be_scraped }

    context 'when job posting is not scraped' do
      subject { build(:job_posting, :claimed_by_organization) }

      it { is_expected.not_to be_scraped }
    end
  end
end
