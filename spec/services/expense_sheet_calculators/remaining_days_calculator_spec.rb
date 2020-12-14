# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpenseSheetCalculators::RemainingDaysCalculator, type: :service do
  let(:calculator) { described_class.new(service) }
  let(:service) { instance_double Service }
  let(:eligible_sick_days) { 0 }
  let(:used_sick_days) { 0 }
  let(:eligible_paid_vacation_days) { 0 }
  let(:used_paid_vacation_days) { 0 }

  before do
    allow(service).to receive(:eligible_sick_days).and_return(eligible_sick_days)
    allow(service).to receive(:used_sick_days).and_return(used_sick_days)
    allow(service).to receive(:eligible_paid_vacation_days).and_return(eligible_paid_vacation_days)
    allow(service).to receive(:used_paid_vacation_days).and_return(used_paid_vacation_days)
  end

  describe '#remaining_days' do
    subject { calculator.remaining_days }

    let(:eligible_sick_days) { 6 }
    let(:used_sick_days) { 1 }
    let(:eligible_paid_vacation_days) { 8 }
    let(:used_paid_vacation_days) { 7 }

    let(:expected_remaining_days) do
      {
        remaining_paid_vacation_days: 1,
        remaining_sick_days: 5
      }
    end

    it { is_expected.to eq expected_remaining_days }
  end

  describe '#remaining_sick_days' do
    subject { calculator.remaining_sick_days }

    context 'without eligible_sick_days' do
      it { is_expected.to eq 0 }
    end

    context 'with eligible_sick_days' do
      let(:eligible_sick_days) { 6 }

      context 'without used_sick_days' do
        it { is_expected.to eq 6 }
      end

      context 'with used_sick_days' do
        let(:used_sick_days) { 4 }

        it { is_expected.to eq 2 }
      end
    end
  end

  describe '#remaining_paid_vacation_days' do
    subject { calculator.remaining_paid_vacation_days }

    context 'without eligible_paid_vacation_days' do
      it { is_expected.to eq 0 }
    end

    context 'with eligible_paid_vacation_days' do
      let(:eligible_paid_vacation_days) { 6 }

      context 'without used_paid_vacation_days' do
        it { is_expected.to eq 6 }
      end

      context 'with used_paid_vacation_days' do
        let(:used_paid_vacation_days) { 4 }

        it { is_expected.to eq 2 }
      end
    end
  end
end
