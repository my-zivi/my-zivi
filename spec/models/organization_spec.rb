# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organization, type: :model do
  describe 'model definition' do
    subject(:model) { described_class.new }

    it 'defines relations correctly' do
      expect(model).to belong_to(:address).class_name('Address')
      expect(model).to belong_to(:letter_address).class_name('Address').optional(true)
      expect(model).to belong_to(:creditor_detail).optional(true)
      expect(model).to have_many(:organization_members)
    end
  end

  describe 'validations' do
    subject(:model) { described_class.new }

    it_behaves_like 'validates presence of required fields', %i[name identification_number]
  end

  describe '#thumb_icon' do
    subject { organization.thumb_icon }

    let(:organization) { build(:organization, :with_icon) }

    it { is_expected.to be_a ActiveStorage::Variant }

    context 'when no icon has been attached yet' do
      let(:organization) { build(:organization) }

      it { is_expected.to be_nil }
    end
  end

  describe 'after commit callback' do
    let(:organization) { create(:organization, :with_admin, job_postings: [build(:job_posting)]) }

    before do
      allow(organization.job_postings).to receive(:reindex!).and_return true
    end

    it 'reindexes the attached job postings' do
      organization.update(icon: attributes_for(:organization, :with_icon)[:icon])
      expect(organization.job_postings).to have_received(:reindex!)
    end

    context 'when no job postings are attached' do
      let(:organization) { create(:organization, :with_admin, job_postings: []) }

      it 'does not attempt to reindex' do
        organization.update(icon: attributes_for(:organization, :with_icon)[:icon])
        expect(organization.job_postings).not_to have_received(:reindex!)
      end
    end
  end
end
