# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HolidayCalculator, type: :service do
  let(:beginning) { Date.parse('2017-12-01') }
  let(:ending) { Date.parse('2018-01-31') }
  let(:organization_holiday_calculator) { described_class.new(beginning, ending) }

  describe '#calculate_company_holiday_days' do
    subject { holiday_calculator.calculate_company_holiday_days }

    before do
      create :organization_holiday, beginning: '2018-01-01', ending: '2018-01-07'
    end

    context 'when there are no public holidays' do
      context 'when there is one company holiday' do
        it { is_expected.to eq 5 }
      end

      context 'when there are overlapping company holidays' do
        before do
          create :organization_holiday, beginning: '2018-01-02', ending: '2018-01-15'
        end

        it { is_expected.to eq 11 }
      end
    end

    context 'when there are public holidays' do
      context 'when there is one company holiday' do
        it { is_expected.to eq 2 }
      end

      context 'when there are overlapping company holidays' do
        before do
          create :organization_holiday, beginning: '2018-01-04', ending: '2018-01-15'
        end

        it { is_expected.to eq 3 }
      end
    end
  end

  describe '#calculate_public_holiday_days' do
    subject { holiday_calculator.calculate_public_holiday_days }

    context 'when there is one public holiday' do
      it { is_expected.to eq 5 }
    end

    context 'when there are overlapping public holidays' do

      it { is_expected.to eq 11 }
    end
  end
end
