# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DayCalculator, type: :service do
  let(:beginning) { Date.parse('2017-11-27') }
  let(:ending) { Date.parse('2018-02-04') }
  let(:day_calculator) { DayCalculator.new(beginning, ending) }

  let(:create_public_holidays) do
    create :holiday, :public_holiday, beginning: '2018-01-01', ending: '2018-01-07'
    create :holiday, :public_holiday, beginning: '2018-01-20', ending: '2018-01-24'
  end
  let(:create_company_holidays) do
    create :holiday, beginning: '2018-01-01', ending: '2018-01-07'
    create :holiday, beginning: '2017-12-20', ending: '2017-12-28'
  end

  describe '#calculate_workfree_days' do
    subject { day_calculator.calculate_workfree_days }

    context 'when there are no public holidays' do
      it { is_expected.to eq 20 }
    end

    context 'when there are public holidays' do
      before { create_public_holidays }

      it { is_expected.to eq 28 }
    end
  end

  describe '#calculate_work_days' do
    subject { day_calculator.calculate_work_days }

    context 'when there are no public holidays' do
      context 'when there are no company holidays' do
        it { is_expected.to eq 50 }
      end

      context 'when there are company holidays' do
        before { create_company_holidays }

        it { is_expected.to eq 38 }
      end
    end

    context 'when there are public holidays' do
      before { create_public_holidays }

      context 'when there are no company holidays' do
        it { is_expected.to eq 42 }
      end

      context 'when there are company holidays' do
        before { create_company_holidays }

        it { is_expected.to eq 35 }
      end
    end
  end
end
