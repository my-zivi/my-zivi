# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CivilServant, type: :model do
  describe 'validations' do
    subject(:model) { described_class.new }

    it 'validates the model correctly', :aggregate_failures do
      expect(model).to validate_numericality_of(:zdp)
                         .only_integer
                         .is_less_than(999_999)
                         .is_greater_than(10_000)
    end

    it_behaves_like 'validates presence of required fields', %i[
      first_name
      last_name
      address
      iban
      birthday
      health_insurance
      hometown
      phone
    ]

    describe 'uniqueness validations' do
      subject(:civil_servant) { build(:civil_servant, :full) }

      it 'validates uniqueness of #zdp' do
        expect(civil_servant).to validate_uniqueness_of(:zdp)
      end
    end

    describe '#iban' do
      it 'validates iban correctly', :aggregate_failures do
        expect(model).not_to allow_value('CH93 0076 2011 6238 5295 7').for(:iban)
        expect(model).not_to allow_value('CH93007620116238529577').for(:iban)
        expect(model).not_to allow_value('CH9300762011623852956').for(:iban)
        expect(model).not_to allow_value('XX9300762011623852957').for(:iban)

        expect(model).to allow_value('CH9300762011623852957').for(:iban)
      end
    end

    describe '#self.strip_iban' do
      it 'removes whitespaces from iban' do
        expect(described_class.strip_iban(' CH56 0483 5012 3456 7800 9')).to eq 'CH5604835012345678009'
      end
    end

    describe '#prettified_iban' do
      subject { build(:civil_servant, iban: ugly_iban).prettified_iban }

      let(:ugly_iban) { 'CH5604835012345678009' }
      let(:nice_iban) { 'CH56 0483 5012 3456 7800 9' }

      it { is_expected.to eq nice_iban }
    end

    describe '#full_name' do
      subject { build(:civil_servant, first_name: 'Peter', last_name: 'Zivi').full_name }

      it { is_expected.to eq 'Peter Zivi' }
    end

    describe '#active?' do
      subject { civil_servant.active? }

      let(:civil_servant) { build(:civil_servant, services: [service]) }
      let(:ending) { (beginning + 4.weeks).at_end_of_week - 2.days }
      let(:service) { build :service, beginning: beginning, ending: ending }

      context 'when the civil_servant is currently doing civil service' do
        let(:beginning) { Time.zone.today.at_beginning_of_week }

        it { is_expected.to eq true }
      end

      context 'when the civil_servant is not doing civil service' do
        let(:beginning) { Time.zone.today.at_beginning_of_week + 1.week }

        it { is_expected.to eq false }
      end

      context 'when the civil service he\'s currently doing ends today' do
        let(:beginning) { Time.zone.today.at_beginning_of_week - 1.week }
        let(:service) { build :service, :last, beginning: beginning, ending: Time.zone.today }

        it { is_expected.to eq true }
      end
    end

    describe '#active_service' do
      subject(:civil_servant) { build(:civil_servant, services: services) }

      let(:services) { [past_service, future_service, current_service] }
      let(:now) { Time.zone.today }
      let(:past_service) { build_stubbed :service, beginning: now - 2.months, ending: now - 3.weeks }
      let(:current_service) { build_stubbed :service, beginning: now - 1.month, ending: now + 4.weeks }
      let(:future_service) { build_stubbed :service, beginning: now + 2.months, ending: now + 4.months }

      it 'returns the service which the civil_servant is currently doing' do
        expect(civil_servant.active_service).to be current_service
      end
    end

    describe '#next_service' do
      subject(:civil_servant) { build(:civil_servant, services: services) }

      let(:services) { [second_future_service, future_service, current_service] }
      let(:now) { Time.zone.today }
      let(:current_service) { build :service, beginning: now - 1.month, ending: now + 4.weeks }
      let(:future_service) { build :service, beginning: now + 2.months, ending: now + 4.months }
      let(:second_future_service) { build :service, beginning: now + 1.year, ending: now + 1.year + 4.weeks }

      it 'returns the service which the civil_servant is currently doing' do
        expect(civil_servant.next_service).to be future_service
      end
    end
  end
end
