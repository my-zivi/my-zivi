# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobPosting, type: :model do
  subject(:model) { build(:job_posting).tap(&:validate) }

  it_behaves_like 'sluggable model', factory_name: :job_posting
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
        I18n.t('activerecord.enums.job_posting.category_abbreviations.nature_conservancy')
      )

      expect(job_posting.full_category_display_name).to eq(
        I18n.t('activerecord.enums.job_posting.categories.nature_conservancy')
      )
    end
  end

  describe '#sub_category_display_name' do
    subject { build(:job_posting).sub_category_display_name }

    it { is_expected.to eq I18n.t('activerecord.enums.job_posting.sub_categories.landscaping_and_gardening') }

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

  describe '#icon_url' do
    subject { job_posting.icon_url }

    let(:job_posting) { build(:job_posting, organization: organization) }
    let(:organization) { build(:organization, :with_icon) }

    it 'returns the url to the attached icon of the organization' do
      expect(job_posting.icon_url).to match(%r{.+/example_icon\.png\z})
    end

    context 'when organization has no icon attached' do
      let(:organization) { build(:organization) }

      it { is_expected.to eq described_class::DEFAULT_ICON_URL }
    end

    context 'when job posting has no organization' do
      let(:job_posting) { build(:job_posting) }

      it { is_expected.to eq described_class::DEFAULT_ICON_URL }
    end
  end

  describe '#default_slug' do
    subject { job_posting.default_slug }

    let(:job_posting) { build(:job_posting, identification_number: 123_456) }

    it { is_expected.to eq '123456-gruppeneinsatz-naturschutz' }

    context 'with non-6 digit identification number' do
      let(:job_posting) { build(:job_posting, identification_number: 5) }

      it { is_expected.to eq '000005-gruppeneinsatz-naturschutz' }
    end
  end
end
