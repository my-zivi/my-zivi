# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DayCalculator, type: :service do
  let(:beginning) { Date.parse('2019-11-25') }
  let(:ending) { Date.parse('2020-01-31') }
  let(:organization) { create(:organization, letter_address: nil) }
  let(:day_calculator) { described_class.new(beginning, ending, organization) }

  let(:create_company_holidays) do
    create(:organization_holiday, beginning: '2020-01-13', ending: '2020-01-19', organization: organization)
  end

  describe '#calculate_workfree_days' do
    subject { day_calculator.calculate_workfree_days }

    context 'when there are no public holidays' do
      let(:beginning) { Date.parse('2020-01-06') }

      it { is_expected.to eq 6 }
    end

    context 'when there are public holidays' do
      let(:beginning) { Date.parse('2019-12-30') }
      let(:ending) { Date.parse('2020-01-24') }

      it { is_expected.to eq 7 }
    end
  end

  describe '#calculate_work_days' do
    subject { day_calculator.calculate_work_days }

    context 'when there are no public holidays' do
      let(:beginning) { Date.parse('2020-01-06') }

      context 'when there are no company holidays' do
        it { is_expected.to eq 20 }
      end

      context 'when there are company holidays' do
        before { create_company_holidays }

        it { is_expected.to eq 15 }
      end
    end

    context 'when there are public holidays' do
      let(:beginning) { Date.parse('2019-12-30') }
      let(:ending) { Date.parse('2020-01-24') }

      context 'when there are no company holidays' do
        it { is_expected.to eq 19 }
      end

      context 'when there are company holidays' do
        before { create_company_holidays }

        it { is_expected.to eq 14 }
      end
    end
  end
end
