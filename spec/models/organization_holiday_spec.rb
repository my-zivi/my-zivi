# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganizationHoliday, type: :model do
  it { is_expected.to belong_to(:organization) }

  describe 'validations' do
    subject(:model) { described_class.new }

    it_behaves_like 'validates presence of required fields', %i[beginning ending description]

    it_behaves_like 'validates that the ending is after beginning' do
      let(:model) { build(:organization_holiday, beginning: beginning, ending: ending) }
    end
  end

  describe '#range' do
    subject(:holiday) { build(:organization_holiday, beginning: beginning, ending: ending) }

    let(:beginning) { Date.parse('2019-04-10') }
    let(:ending) { Date.parse('2019-04-20') }

    it 'returns range of beginning and ending' do
      expect(holiday.range).to eq beginning..ending
    end
  end

  describe '#work_days' do
    let(:holiday) do
      build(:organization_holiday, beginning: Date.parse('2019-07-20'), ending: Date.parse('2019-08-03'))
    end

    context 'with one public holidays' do
      let(:expected_work_days) do
        %w[
          2019-07-22
          2019-07-23
          2019-07-24
          2019-07-25
          2019-07-26
          2019-07-29
          2019-07-30
          2019-07-31
          2019-08-02
        ].map { |date| Date.parse date }
      end

      it 'returns only work days without public holidays' do
        expect(holiday.work_days).to eq expected_work_days
      end
    end

    context 'with no public holidays' do
      let(:holiday) do
        build(:organization_holiday, beginning: Date.parse('2019-07-20'), ending: Date.parse('2019-07-31'))
      end

      let(:expected_work_days) do
        %w[
          2019-07-22
          2019-07-23
          2019-07-24
          2019-07-25
          2019-07-26
          2019-07-29
          2019-07-30
          2019-07-31
        ].map { |date| Date.parse date }
      end

      it { expect(holiday.work_days).to eq expected_work_days }
    end
  end
end
