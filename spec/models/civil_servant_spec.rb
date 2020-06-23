# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CivilServant, type: :model do
  describe 'model definition' do
    subject(:model) { described_class.new }

    it 'defines relations' do
      expect(model).to have_many(:services)
      expect(model).to have_many(:expense_sheets).through(:services)
      expect(model).to have_many(:civil_servants_driving_licenses)
      expect(model).to have_many(:driving_licenses).through(:civil_servants_driving_licenses)
      expect(model).to have_many(:civil_servants_workshops)
      expect(model).to have_many(:workshops).through(:civil_servants_workshops)
      expect(model).to have_one(:user).dependent(:destroy).required(true)
      expect(model).to belong_to(:regional_center)
      expect(model).to belong_to(:address)
    end
  end

  describe 'validations' do
    subject(:model) { described_class.new }

    before { create :civil_servant, :full }

    let(:invalid_ibans) do
      %w[
        CH93\ 0076\ 2011\ 6238\ 5295\ 7
        CH93007620116238529577
        CH9300762011623852956
        XX9300762011623852957
      ]
    end

    it 'validates the model correctly' do
      expect(model).to validate_uniqueness_of(:zdp)
      expect(model).to validate_numericality_of(:zdp).only_integer.is_less_than(999_999).is_greater_than(10_000)

      expect(model).to allow_value('CH9300762011623852957').for(:iban)
      invalid_ibans.each do |invalid_iban|
        expect(model).not_to allow_value(invalid_iban).for(:iban)
      end
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
      zdp
    ]
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
    let(:past_service) { build_stubbed :service, beginning: 2.months.ago, ending: 3.weeks.ago }
    let(:current_service) { build_stubbed :service, beginning: 1.month.ago, ending: 4.weeks.from_now }
    let(:future_service) { build_stubbed :service, beginning: 2.months.from_now, ending: 4.months.from_now }

    it 'returns the service which the civil_servant is currently doing' do
      expect(civil_servant.active_service).to be current_service
    end
  end

  describe '#next_service' do
    subject(:civil_servant) { build(:civil_servant, services: services) }

    let(:services) { [second_future_service, future_service, current_service] }
    let(:current_service) { build :service, beginning: 1.month.ago, ending: 4.weeks.from_now }
    let(:future_service) { build :service, beginning: 2.months.from_now, ending: 4.months.from_now }
    let(:second_future_service) { build :service, beginning: 1.year.from_now, ending: (1.year + 4.weeks).from_now }

    it 'returns the service which the civil_servant is currently doing' do
      expect(civil_servant.next_service).to be future_service
    end
  end
end
