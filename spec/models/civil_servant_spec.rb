# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CivilServant, type: :model do
  describe 'model definition' do
    subject(:model) { described_class.new }

    it { is_expected.to have_one(:user).dependent(:destroy).required(true) }

    describe 'foreign relations' do
      it 'defines has_many relations' do
        expect(model).to have_many(:services)
        expect(model).to have_many(:expense_sheets).through(:services)
        expect(model).to have_many(:civil_servants_driving_licenses)
        expect(model).to have_many(:driving_licenses).through(:civil_servants_driving_licenses)
        expect(model).to have_many(:civil_servants_workshops)
        expect(model).to have_many(:workshops).through(:civil_servants_workshops)
      end
    end

    describe 'owned relationships' do
      it 'defines belongs_to relations' do
        expect(model).to belong_to(:address).optional
      end
    end
  end

  describe 'validations' do
    subject(:model) { build(:civil_servant, :service_specific_step_completed) }

    before { create(:civil_servant, :full) }

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

  describe 'active record callbacks' do
    let(:model) { create :civil_servant, :full }
    let(:address) { model.address }

    let(:new_last_name) { 'NeueNachname' }

    context 'when model gets a valid update' do
      it 'updates the addresses primary line' do
        expect { model.update(last_name: new_last_name) }.to change(address, :primary_line)
          .from(model.full_name)
          .to("#{model.first_name} #{new_last_name}")
      end
    end

    context 'when model gets an invalid update' do
      let(:new_last_name) { nil }

      it 'does not update the addresses primary line' do
        expect { model.update(last_name: new_last_name) }.not_to change(address, :primary_line)
      end
    end

    context 'when the address update throws an error' do
      before do
        allow(address).to receive(:update!).and_raise(ActiveRecord::RecordInvalid.new)
        stub_const('Sentry', instance_double('Sentry', capture_exception: true))
      end

      it 'calls raven on exception' do
        expect { model.update(last_name: new_last_name) }.not_to change(address, :primary_line)
        expect(Sentry).to have_received(:capture_exception)
          .with(be_an_instance_of(ActiveRecord::RecordInvalid),
                extra: address.errors)
      end
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

  describe '#in_service?' do
    subject { civil_servant.in_service? }

    let(:civil_servant) { build(:civil_servant, services: [service]) }
    let(:ending) { (beginning + 4.weeks).at_end_of_week - 2.days }
    let(:service) { build :service, beginning: beginning, ending: ending }

    context 'when the civil_servants is currently doing civil service' do
      let(:beginning) { Time.zone.today.at_beginning_of_week }

      it { is_expected.to eq true }
    end

    context 'when the civil_servants is not doing civil service' do
      let(:beginning) { Time.zone.today.at_beginning_of_week + 1.week }

      it { is_expected.to eq false }
    end

    context 'when the civil service he\'s currently doing ends today' do
      let(:beginning) { Time.zone.today.at_beginning_of_week - 1.week }
      let(:service) { build(:service, :last, beginning: beginning, ending: Time.zone.today) }

      it { is_expected.to eq true }
    end
  end

  describe '#active_service' do
    subject(:active_service) { civil_servant.active_service }

    let(:civil_servant) { build(:civil_servant, services: [past_service, future_service, current_service]) }
    let(:past_service) { build_stubbed(:service, beginning: 2.months.ago, ending: 3.weeks.ago) }
    let(:current_service) { build_stubbed(:service, **current_service_attributes) }
    let(:future_service) { build_stubbed(:service, beginning: 2.months.from_now, ending: 4.months.from_now) }
    let(:current_service_attributes) { { beginning: 1.month.ago, ending: 4.weeks.from_now } }

    it 'returns the service which the civil_servants is currently doing' do
      expect(active_service).to be current_service
    end

    context 'when an organization is given' do
      subject { civil_servant.active_service(organization) }

      let(:organization) { create(:organization, :with_admin) }
      let(:service_specification) { create(:service_specification, organization: organization) }

      context 'when current service is in given organization' do
        let(:current_service_attributes) do
          { beginning: 1.month.ago, ending: 4.weeks.from_now, service_specification: service_specification }
        end

        it { is_expected.to be current_service }
      end

      context 'when current service is outside of given organization' do
        it { is_expected.to be_nil }
      end
    end
  end

  describe '#next_service' do
    subject(:civil_servant) { build(:civil_servant, services: services) }

    let(:services) { [second_future_service, future_service, current_service] }
    let(:current_service) { build(:service, beginning: 1.month.ago, ending: 4.weeks.from_now) }
    let(:future_service) { build(:service, beginning: 2.months.from_now, ending: 4.months.from_now) }
    let(:second_future_service) { build(:service, beginning: 1.year.from_now, ending: (1.year + 4.weeks).from_now) }

    it 'returns the service which the civil_servants is currently doing' do
      expect(civil_servant.next_service).to be future_service
    end
  end
end
