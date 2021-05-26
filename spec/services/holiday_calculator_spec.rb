# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HolidayCalculator, type: :service do
  let(:beginning) { Date.parse('2019-12-30') }
  let(:ending) { Date.parse('2020-01-31') }
  let(:organization) { create(:organization) }
  let(:holiday_calculator) { described_class.new(beginning, ending, organization) }

  describe '#calculate_company_holiday_days' do
    subject { holiday_calculator.calculate_company_holiday_days }

    before do
      create(:organization_holiday, beginning: '2020-01-13', ending: '2020-01-19', organization: organization)
    end

    context 'when there are no public holidays' do
      let(:beginning) { Date.parse('2020-01-06') }

      context 'when there is one company holiday' do
        it { is_expected.to eq 5 }
      end

      context 'when there are overlapping company holidays' do
        before do
          create(:organization_holiday, beginning: '2020-01-16', ending: '2020-01-21', organization: organization)
        end

        it { is_expected.to eq 7 }
      end

      context 'when the company holidays are from a different organization' do
        before do
          create(:organization_holiday,
                 beginning: '2020-01-16',
                 ending: '2020-01-21',
                 organization: create(:organization))
        end

        it { is_expected.to eq 5 }
      end
    end

    context 'when there are public holidays' do
      context 'when there is one company holiday' do
        it { is_expected.to eq 5 }
      end

      context 'when there are overlapping company holidays' do
        before do
          create(:organization_holiday, beginning: '2020-01-16', ending: '2020-01-21', organization: organization)
        end

        it { is_expected.to eq 7 }
      end
    end
  end

  describe '#calculate_public_holiday_days' do
    subject { holiday_calculator.calculate_public_holiday_days }

    context 'when there is one public holiday' do
      it { is_expected.to eq 1 }
    end
  end
end
