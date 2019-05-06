# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ServiceCalculator, type: :service do
  describe '#calculate_ending_date' do
    subject { calculated_ending_day - beginning }

    let(:calculated_ending_day) { ServiceCalculator.new(beginning).calculate_ending_date(required_service_days) }
    let(:beginning) { Time.zone.today.beginning_of_week }
    let(:required_service_days) { 26 }

    context 'when service duration is between 1 and 5' do
      it 'returns correct ending date', :aggregate_failures do
        (1..5).each do |delta|
          ending = ServiceCalculator.new(beginning).calculate_ending_date(delta)
          expect((ending - beginning).to_i).to eq(delta - 1)
        end
      end
    end

    context 'when service duration is 6' do
      let(:required_service_days) { 6 }

      it { is_expected.to eq 7 }
    end

    context 'when service duration is between 7 and 10' do
      it_behaves_like 'adds one day to linear duration', 7..10
    end

    context 'when service duration is 11' do
      let(:required_service_days) { 11 }

      it { is_expected.to eq 10 }
    end

    context 'when service duration is 12' do
      let(:required_service_days) { 12 }

      it { is_expected.to eq 11 }
    end

    context 'when service duration is 13' do
      let(:required_service_days) { 13 }

      it { is_expected.to eq 14 }
    end

    context 'when service duration is between 14 and 17' do
      it_behaves_like 'adds one day to linear duration', 14..17
    end

    context 'when service duration is 18' do
      let(:required_service_days) { 18 }

      it { is_expected.to eq 17 }
    end

    context 'when service duration is 19' do
      let(:required_service_days) { 19 }

      it { is_expected.to eq 18 }
    end

    context 'when service duration is 20' do
      let(:required_service_days) { 20 }

      it { is_expected.to eq 21 }
    end

    context 'when service duration is between 21 and 24' do
      it_behaves_like 'adds one day to linear duration', 21..24
    end

    context 'when service duration is 25' do
      let(:required_service_days) { 25 }

      it { is_expected.to eq 24 }
    end

    context 'when service duration is above irregular threshold' do
      context 'when service end is on weekend' do
        context 'when it\'s a saturday' do
          let(:required_service_days) { 27 }

          it { is_expected.to eq 28 }
        end

        context 'when it\'s a sunday' do
          let(:required_service_days) { 28 }

          it { is_expected.to eq 28 }
        end
      end

      context 'when service end is a weekday' do
        let(:required_service_days) { 30 }

        it { is_expected.to eq 29 }
      end
    end

    context 'when service duration is invalid' do
      subject { -> { ServiceCalculator.new(beginning).calculate_ending_date(required_service_days) } }

      let(:required_service_days) { 0 }

      it { is_expected.to raise_error(I18n.t('service_calculator.invalid_required_service_days')) }
    end
  end

  describe '#calculate_chargeable_service_days' do
    subject { calculate_chargeable_service_days }

    let(:beginning) { Time.zone.today.at_beginning_of_week }
    let(:ending) { beginning }
    let(:calculate_chargeable_service_days) do
      ServiceCalculator.new(beginning).calculate_chargeable_service_days(ending)
    end

    context 'when service end is withing weekdays of beginning week' do
      it 'returns correct eligible days', :aggregate_failures do
        (0..4).each do |delta|
          service_days = ServiceCalculator.new(beginning).calculate_chargeable_service_days(beginning + delta.days)
          expect(service_days).to eq(delta + 1)
        end
      end
    end

    context 'when service end is a weekend' do
      subject { -> { calculate_chargeable_service_days } }

      let(:ending) { beginning.at_end_of_week }

      it { is_expected.to raise_error I18n.t('service_calculator.end_date_cannot_be_on_weekend') }
    end

    context 'when ending is the monday after one week' do
      let(:ending) { beginning + 1.week }

      it { is_expected.to eq 7 }
    end

    context 'when ending is the tuesday after one week' do
      let(:ending) { beginning + 1.week + 1.day }

      it { is_expected.to eq 8 }
    end

    context 'when ending is the wednesday after one week' do
      let(:ending) { beginning + 1.week + 2.days }

      it { is_expected.to eq 9 }
    end

    context 'when ending is the thursday after one week' do
      let(:ending) { beginning + 1.week + 3.days }

      it { is_expected.to eq 11 }
    end

    context 'when ending is the friday after one week' do
      let(:ending) { beginning + 1.week + 4.days }

      it { is_expected.to eq 12 }
    end

    context 'when ending is the monday after two weeks' do
      let(:ending) { beginning + 2.weeks }

      it { is_expected.to eq 14 }
    end

    context 'when ending is the tuesday after two weeks' do
      let(:ending) { beginning + 2.weeks + 1.day }

      it { is_expected.to eq 15 }
    end

    context 'when ending is the wednesday after two weeks' do
      let(:ending) { beginning + 2.weeks + 2.days }

      it { is_expected.to eq 16 }
    end

    context 'when ending is the thursday after two weeks' do
      let(:ending) { beginning + 2.weeks + 3.days }

      it { is_expected.to eq 18 }
    end

    context 'when ending is the friday after two weeks' do
      let(:ending) { beginning + 2.weeks + 4.days }

      it { is_expected.to eq 19 }
    end

    context 'when ending is the monday after three weeks' do
      let(:ending) { beginning + 3.weeks }

      it { is_expected.to eq 21 }
    end

    context 'when ending is the tuesday after three weeks' do
      let(:ending) { beginning + 3.weeks + 1.day }

      it { is_expected.to eq 22 }
    end

    context 'when ending is the wednesday after three weeks' do
      let(:ending) { beginning + 3.weeks + 2.days }

      it { is_expected.to eq 23 }
    end

    context 'when ending is the thursday after three weeks' do
      let(:ending) { beginning + 3.weeks + 3.days }

      it { is_expected.to eq 25 }
    end

    context 'when ending is the monday after four weeks' do
      let(:ending) { beginning + 4.weeks }

      it { is_expected.to eq 29 }
    end
  end
end
