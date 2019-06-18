# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompanyHolidayCalculator, type: :service do
  describe '#calculate_company_holidays_during_service' do
    subject { company_holiday_calculator.calculate_company_holiday_days_during_service }

    let(:beginning) { Date.parse('2017-12-01') }
    let(:ending) { Date.parse('2018-01-31') }
    let(:company_holiday_calculator) { CompanyHolidayCalculator.new(beginning, ending) }

    before do
      create :holiday, beginning: '2018-01-01', ending: '2018-01-07'
    end

    context 'when there are no public holidays' do
      context 'when there is one company holiday' do
        it { is_expected.to eq 5 }
      end

      context 'when there are overlapping company holidays' do
        before do
          create :holiday, beginning: '2018-01-02', ending: '2018-01-15'
        end

        it { is_expected.to eq 11 }
      end
    end

    context 'when there are public holidays' do
      before do
        create :holiday, :public_holiday, beginning: '2017-12-30', ending: '2018-01-02'
        create :holiday, :public_holiday, beginning: '2018-01-05', ending: '2018-01-12'
      end

      context 'when there is one company holiday' do
        it { is_expected.to eq 2 }
      end

      context 'when there are overlapping company holidays' do
        before do
          create :holiday, beginning: '2018-01-04', ending: '2018-01-15'
        end

        it { is_expected.to eq 3 }
      end
    end
  end
end
