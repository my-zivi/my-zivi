# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Service, type: :model do
  describe 'validations' do
    subject(:model) { described_class.new }

    it 'defines relations and enums' do
      expect(model).to belong_to(:civil_servant)
      expect(model).to belong_to(:service_specification)
      expect(model).to have_many(:expense_sheets).dependent(:restrict_with_error)
      expect(model).to define_enum_for(:service_type)
    end

    it_behaves_like 'validates presence of required fields', %i[
      ending
      beginning
      civil_servant
    ]

    it_behaves_like 'validates that the ending is after beginning' do
      let(:model) { build(:service, :last, beginning: beginning, ending: ending) }
    end

    describe '#length_is_valid' do
      subject(:length_error_added) { service.tap(&:validate).errors.added? :service_days, :invalid_length }

      let(:service) { build(:service, beginning: beginning, ending: ending, civil_servant: civil_servant) }
      let(:civil_servant) { create :civil_servant, :full }
      let(:service_range) { get_service_range months: 2 }
      let(:beginning) { service_range.begin }
      let(:ending) { service_range.end }

      it 'is valid when service has a length that is bigger then 26 days' do
        expect(service).to be_valid
      end

      context 'when service has a length that is less then 26 days' do
        let(:service_range) { Date.parse('2018-01-01')..Date.parse('2018-01-19') }

        it 'adds a length error' do
          expect(length_error_added).to eq true
        end
      end

      context 'when service is last' do
        let(:service) do
          build(:service, :last, beginning: beginning, ending: ending, civil_servant: civil_servant)
        end

        it 'is valid when service has a length that is bigger then 26 days' do
          expect(service).to be_valid
        end

        context 'when service has a length that is less then 26 days' do
          let(:service_range) { Date.parse('2018-01-01')..Date.parse('2018-01-19') }

          it 'is still a valid service' do
            expect(service).to be_valid
          end
        end
      end
    end

    describe 'ending_is_friday validation' do
      subject { build(:service, ending: ending).tap(&:validate).errors.added? :ending, :not_a_friday }

      let(:ending) { Time.zone.today.at_end_of_week - 2.days }

      context 'when ending is a friday' do
        it { is_expected.to be false }
      end

      context 'when ending is a saturday' do
        let(:ending) { Time.zone.today.at_end_of_week - 1.day }

        it { is_expected.to be true }
      end
    end

    describe '#beginning_is_monday' do
      subject do
        build(:service, beginning: beginning, ending: ending).tap(&:validate).errors.added?(:beginning, :not_a_monday)
      end

      let(:beginning) { Time.zone.today.at_beginning_of_week }
      let(:ending) { (beginning + 4.weeks).at_end_of_week - 2.days }

      context 'when beginning is a monday' do
        it { is_expected.to be false }
      end

      context 'when beginning is a tuesday' do
        let(:beginning) { Time.zone.today.at_beginning_of_week + 1.day }

        it { is_expected.to be true }
      end
    end

    describe '#no_overlapping_service' do
      subject { service.tap(&:validate).errors.added? :beginning, :overlaps_service }

      let(:service) { build(:service, beginning: beginning, ending: ending, civil_servant: civil_servant) }
      let(:civil_servant) { create(:civil_servant, :full) }
      let(:service_range) { get_service_range months: 2 }
      let(:beginning) { service_range.begin }
      let(:ending) { service_range.end }
      let(:other_beginning) { (service_range.begin - 2.months).at_beginning_of_week }
      let(:other_ending) { (service_range.begin - 1.month).at_end_of_week - 2.days }

      before { create :service, civil_servant: civil_servant, beginning: other_beginning, ending: other_ending }

      context 'when there is no overlapping service' do
        it { is_expected.to be false }
      end

      context 'when there is an overlapping service' do
        let(:other_ending) { service_range.begin.at_end_of_week - 2.days }

        it { is_expected.to be true }
      end
    end
  end

  describe 'delegated methods' do
    subject(:service) { described_class.new }

    it 'delegates the correct methods to calculators' do
      expect(service).to delegate_method(:used_sick_days).to(:used_days_calculator)
      expect(service).to delegate_method(:used_paid_vacation_days).to(:used_days_calculator)
      expect(service).to delegate_method(:remaining_sick_days).to(:remaining_days_calculator)
      expect(service).to delegate_method(:remaining_paid_vacation_days).to(:remaining_days_calculator)
      expect(service).to delegate_method(:future?).to(:beginning)
      expect(service).to delegate_method(:past?).to(:ending)
    end
  end

  describe 'memoization' do
    let(:service) { build :service }
    let(:used_days_calculator) { instance_double ExpenseSheetCalculators::UsedDaysCalculator }
    let(:remaining_days_calculator) { instance_double ExpenseSheetCalculators::RemainingDaysCalculator }

    before do
      allow(ExpenseSheetCalculators::UsedDaysCalculator).to receive(:new).and_return used_days_calculator
      allow(used_days_calculator).to receive(:used_sick_days)
      allow(used_days_calculator).to receive(:used_paid_vacation_days)

      allow(ExpenseSheetCalculators::RemainingDaysCalculator).to receive(:new).and_return remaining_days_calculator
      allow(remaining_days_calculator).to receive(:remaining_sick_days)
      allow(remaining_days_calculator).to receive(:remaining_paid_vacation_days)
    end

    it 'creates a used_days_calculator' do
      service.used_sick_days
      service.used_paid_vacation_days
      expect(ExpenseSheetCalculators::UsedDaysCalculator).to have_received(:new).exactly(1).times
    end

    it 'creates a remaining_days_calculator' do
      service.remaining_sick_days
      service.remaining_paid_vacation_days
      expect(ExpenseSheetCalculators::RemainingDaysCalculator).to have_received(:new).exactly(1).times
    end
  end

  describe '#at_year' do
    subject(:services) { described_class.at_year(2018) }

    before do
      create_pair :service, beginning: '2018-11-05', ending: '2018-11-30'
      create :service, beginning: '2017-02-06', ending: '2018-01-05'
      create :service, beginning: '2017-02-06', ending: '2017-03-24'
    end

    it 'returns only services that are at least partially in this year' do
      expect(services.count).to eq 3
    end
  end

  describe '#service_days' do
    let(:service) { build(:service, beginning: beginning, ending: beginning + 25.days) }
    let(:beginning) { Time.zone.today.beginning_of_week }

    it 'returns the service days of the service' do
      expect(service.service_days).to eq 26
    end
  end

  describe '#eligible_paid_vacation_days' do
    let(:service) { build(:service, :long, beginning: beginning, ending: beginning + 214.days) }
    let(:beginning) { Time.zone.today.beginning_of_week }

    it 'returns the eligible personal vacation days of the service' do
      expect(service.eligible_paid_vacation_days).to eq 10
    end
  end

  describe '#eligible_sick_days' do
    let(:service) { build(:service, beginning: beginning, ending: beginning + 25.days) }
    let(:beginning) { Time.zone.today.beginning_of_week }
    let(:service_calculator) { instance_double ServiceCalculator }

    before do
      allow(ServiceCalculator).to receive(:new).and_return service_calculator
      allow(service_calculator).to receive(:calculate_chargeable_service_days).and_return 26
      allow(service_calculator).to receive(:calculate_eligible_sick_days)
    end

    it 'calls ServiceCalculator#calculate_eligible_sick_days' do
      service.eligible_sick_days
      expect(service_calculator).to have_received(:calculate_eligible_sick_days).with 26
    end
  end

  describe '#future?' do
    subject { build(:service, :last, beginning: beginning, ending: ending).future? }

    let(:ending) { beginning + 26.days }

    context 'when service will start in future' do
      let(:beginning) { 2.weeks.from_now.at_beginning_of_week }

      it { is_expected.to be true }
    end

    context 'when service already started' do
      let(:beginning) { 1.week.ago.at_beginning_of_week }

      it { is_expected.to be false }
    end

    context 'when service starts today' do
      let(:beginning) { Time.zone.today }

      it { is_expected.to be false }
    end
  end

  describe '#current?' do
    subject { build(:service, :last, beginning: beginning, ending: ending).current? }

    let(:ending) { beginning + 26.days }

    context 'when service will start in future' do
      let(:beginning) { 2.weeks.from_now.at_beginning_of_week }

      it { is_expected.to be false }
    end

    context 'when service already started' do
      let(:beginning) { 1.week.ago.at_beginning_of_week }

      it { is_expected.to be true }
    end

    context 'when service starts today' do
      let(:beginning) { Time.zone.today }

      it { is_expected.to be true }
    end

    context 'when service has ended' do
      let(:beginning) { 2.months.ago.at_beginning_of_week }

      it { is_expected.to be false }
    end
  end

  describe '#date_range' do
    subject { build(:service, beginning: beginning, ending: ending).date_range }

    let(:beginning) { Date.parse '2018-10-29' }
    let(:ending) { Date.parse '2018-11-30' }

    it { is_expected.to eq beginning..ending }
  end
end
