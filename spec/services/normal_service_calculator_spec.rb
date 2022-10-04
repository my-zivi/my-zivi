# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NormalServiceCalculator, type: :service do
  let(:beginning) { Date.parse('2018-01-01') }
  let(:organization) { create(:organization, :with_admin) }
  let(:normal_service_calculator) { described_class.new(beginning, organization) }

  context 'when there are no company holidays during service' do
    describe '#calculate_ending_date' do
      subject { calculated_ending_day }

      let(:required_service_days) { 26 }
      let(:calculated_ending_day) { normal_service_calculator.calculate_ending_date(required_service_days) }

      context 'when service days are between 26 and 355' do
        it 'returns linearly added ending date', :aggregate_failures do
          (26..355).each do |delta|
            ending = normal_service_calculator.calculate_ending_date(delta)
            expect(ending).to eq(beginning + delta - 1)
          end
        end
      end
    end

    describe '#calculate_chargeable_service_days' do
      subject { calculate_chargeable_service_days }

      let(:ending) { beginning }
      let(:calculate_chargeable_service_days) { normal_service_calculator.calculate_chargeable_service_days(ending) }

      context 'when ending is between 25 and 354 days after beginning' do
        let(:start_range) { beginning + 25.days }
        let(:end_range) { beginning + 354.days }
        let(:week_days_range) { (start_range..end_range) }

        it 'returns the chargeable service days', :aggregate_failures do
          week_days_range.each do |ending|
            service_days = normal_service_calculator.calculate_chargeable_service_days(ending)
            expect(service_days).to eq((ending - beginning + 1).to_i)
          end
        end
      end
    end

    describe '#calculate_eligible_paid_vacation_days' do
      subject { calculate_eligible_paid_vacation_days }

      let(:service_days) { 0 }
      let(:calculate_eligible_paid_vacation_days) do
        normal_service_calculator.calculate_eligible_paid_vacation_days(service_days)
      end

      context 'when service days are between 0 and 179' do
        it 'returns 0', :aggregate_failures do
          180.times do |days|
            personal_vacation_days = normal_service_calculator.calculate_eligible_paid_vacation_days(days)
            expect(personal_vacation_days).to eq(0)
          end
        end
      end

      context 'when service days are 180' do
        let(:service_days) { 180 }

        it { is_expected.to eq(8) }
      end

      context 'when service days are 209' do
        let(:service_days) { 209 }

        it { is_expected.to eq(8) }
      end

      context 'when service days are 210' do
        let(:service_days) { 210 }

        it { is_expected.to eq(10) }
      end

      context 'when service days are 239' do
        let(:service_days) { 239 }

        it { is_expected.to eq(10) }
      end
    end
  end

  context 'when there are 10 company holiday work days during service' do
    before do
      create(:organization_holiday, beginning: '2018-01-01', ending: '2018-01-05', organization: organization)
      create(:organization_holiday, beginning: '2018-01-07', ending: '2018-01-13', organization: organization)
    end

    describe '#calculate_ending_date' do
      subject { calculated_ending_day }

      let(:required_service_days) { 26 }
      let(:calculated_ending_day) { normal_service_calculator.calculate_ending_date(required_service_days) }

      context 'when service days are 54' do
        let(:required_service_days) { 54 }

        it { is_expected.to eq(Date.parse('2018-03-04')) }
      end

      context 'when service days are 55' do
        let(:required_service_days) { 55 }

        it { is_expected.to eq(Date.parse('2018-03-05')) }
      end

      context 'when service days are 179' do
        let(:required_service_days) { 179 }

        it { is_expected.to eq(Date.parse('2018-07-07')) }
      end

      context 'when service days are 180' do
        let(:required_service_days) { 180 }

        it { is_expected.to eq(Date.parse('2018-06-30')) }
      end

      context 'when service days are 210' do
        let(:required_service_days) { 210 }

        it { is_expected.to eq(Date.parse('2018-07-29')) }
      end
    end

    describe '#calculate_chargeable_service_days' do
      subject { calculate_chargeable_service_days }

      let(:ending) { beginning }
      let(:calculate_chargeable_service_days) { normal_service_calculator.calculate_chargeable_service_days(ending) }

      context 'when length is 180' do
        let(:ending) { beginning + 179 }

        it { is_expected.to eq(171) }
      end

      context 'when duration is 183' do
        let(:ending) { beginning + 182 }

        it { is_expected.to eq(182) }
      end

      context 'when duration is 211' do
        let(:ending) { beginning + 210 }

        it { is_expected.to eq(211) }
      end
    end
  end
end
