# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ServiceCalculator, type: :service do
  let(:beginning) { Date.parse('2018-01-01') }
  let(:service_calculator) { ServiceCalculator.new(beginning) }
  let(:short_service_calculator) do
    instance_double ShortServiceCalculator,
                    calculate_ending_date: true,
                    calculate_chargeable_service_days: true
  end
  let(:normal_service_calculator) do
    instance_double NormalServiceCalculator,
                    calculate_ending_date: true,
                    calculate_chargeable_service_days: true,
                    calculate_eligible_paid_vacation_days: true
  end

  before do
    allow(ShortServiceCalculator).to receive(:new).and_return short_service_calculator
    allow(NormalServiceCalculator).to receive(:new).and_return normal_service_calculator
  end

  describe '#calculate_ending_date' do
    context 'when service days are 26 or over' do
      before { service_calculator.calculate_ending_date(26) }

      it 'routes to NormalServiceCalculator' do
        expect(normal_service_calculator).to have_received(:calculate_ending_date).with(26)
      end
    end

    context 'when service days are under 26' do
      before { service_calculator.calculate_ending_date(25) }

      it 'routes to ShortServiceCalculator' do
        expect(short_service_calculator).to have_received(:calculate_ending_date).with(25)
      end
    end
  end

  describe '#calculate_chargeable_service_days' do
    context 'when duration is 26 or over' do
      before { service_calculator.calculate_chargeable_service_days(beginning + 25) }

      it 'routes to NormalServiceCalculator' do
        expect(normal_service_calculator).to have_received(:calculate_chargeable_service_days).with(beginning + 25)
      end
    end

    context 'when duration is under 26' do
      before { service_calculator.calculate_chargeable_service_days(beginning + 24) }

      it 'routes to ShortServiceCalculator' do
        expect(short_service_calculator).to have_received(:calculate_chargeable_service_days).with(beginning + 24)
      end
    end
  end

  describe '#calculate_eligible_paid_vacation_days' do
    context 'when service days are 180 or over' do
      before { service_calculator.calculate_eligible_paid_vacation_days(180) }

      it 'routes to NormalServiceCalculator' do
        expect(normal_service_calculator).to have_received(:calculate_eligible_paid_vacation_days).with(180)
      end
    end

    context 'when service days are under 180' do
      it 'returns 0' do
        days = service_calculator.calculate_eligible_paid_vacation_days(179)
        expect(days).to eq(0)
      end
    end
  end
end
