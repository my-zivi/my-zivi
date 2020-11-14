# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ServiceCalculator, type: :service do
  let(:beginning) { Date.parse('2018-01-01') }
  let(:service_calculator) { described_class.new(beginning, last_civil_service, false) }
  let(:last_civil_service) { false }
  let(:probation_civil_service) { false }
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
    context 'when service days are 0 or negative' do
      subject(:calculate_ending_date) { service_calculator.calculate_ending_date(0) }

      it do
        expect { calculate_ending_date }.to raise_error(
          CalculationError,
          I18n.t('service_calculator.invalid_required_service_days')
        )
      end
    end

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

    context 'when service is probation service' do
      let(:probation_civil_service) { true }

      context 'when service days are 0 or negative' do
        subject(:calculate_ending_date) { service_calculator.calculate_ending_date(0) }

        it do
          expect { calculate_ending_date }.to raise_error(
            CalculationError,
            I18n.t('service_calculator.invalid_required_service_days')
          )
        end
      end

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
  end

  describe '#calculate_chargeable_service_days' do
    context 'when duration is 26 or over' do
      before { service_calculator.calculate_chargeable_service_days(beginning + 25.days) }

      it 'routes to NormalServiceCalculator' do
        expect(normal_service_calculator).to have_received(:calculate_chargeable_service_days).with(beginning + 25)
      end
    end

    context 'when duration is under 26' do
      before { service_calculator.calculate_chargeable_service_days(beginning + 24.days) }

      it 'routes to ShortServiceCalculator' do
        expect(short_service_calculator).to have_received(:calculate_chargeable_service_days).with(beginning + 24)
      end
    end

    context 'when duration is invalid' do
      context 'when is not a last civil service' do
        it 'raises error' do
          expect do
            service_calculator.calculate_chargeable_service_days(beginning + 27.days)
          end.to raise_error CalculationError
        end
      end

      context 'when is a last civil service' do
        let(:last_civil_service) { true }

        it 'does not raises error' do
          expect do
            service_calculator.calculate_chargeable_service_days(beginning + 27.days)
          end.not_to raise_error
        end
      end
    end

    context 'when service is probation service' do
      let(:probation_civil_service) { true }

      context 'when duration is 26 or over' do
        before { service_calculator.calculate_chargeable_service_days(beginning + 25.days) }

        it 'routes to NormalServiceCalculator' do
          expect(normal_service_calculator).to have_received(:calculate_chargeable_service_days).with(beginning + 25)
        end
      end

      context 'when duration is under 26' do
        before { service_calculator.calculate_chargeable_service_days(beginning + 24.days) }

        it 'routes to ShortServiceCalculator' do
          expect(short_service_calculator).to have_received(:calculate_chargeable_service_days).with(beginning + 24)
        end
      end

      context 'when duration is invalid' do
        context 'when is not a last civil service' do
          it 'raises error' do
            expect do
              service_calculator.calculate_chargeable_service_days(beginning + 27.days)
            end.to raise_error CalculationError
          end
        end

        context 'when is a last civil service' do
          let(:last_civil_service) { true }

          it 'does not raises error' do
            expect do
              service_calculator.calculate_chargeable_service_days(beginning + 27.days)
            end.not_to raise_error
          end
        end
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

    context 'when service is probation service' do
      let(:probation_civil_service) { true }

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

  describe '#calculate_eligible_sick_days' do
    let(:service_days) { 20 }

    before do
      allow(SickDaysCalculator).to receive(:calculate_eligible_sick_days)
      service_calculator.calculate_eligible_sick_days(service_days)
    end

    it 'calls SickDaysCalculator.calculate_eligible_sick_days' do
      expect(SickDaysCalculator).to have_received(:calculate_eligible_sick_days).with(service_days)
    end


    context 'when service is probation service' do
      let(:probation_civil_service) { true }
      let(:service_days) { 21 }

      it 'calls SickDaysCalculator.calculate_eligible_sick_days' do
        expect(SickDaysCalculator).to have_received(:calculate_eligible_sick_days).with(service_days)
      end
    end
  end
end
