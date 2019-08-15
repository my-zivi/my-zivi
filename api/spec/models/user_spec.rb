# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject(:model) { described_class.new }

    it { is_expected.to validate_numericality_of(:zip).only_integer }

    it_behaves_like 'validates presence of required fields', %i[
      first_name
      last_name
      email
      address
      bank_iban
      birthday
      city
      health_insurance
      role
      zip
      hometown
      phone
    ]

    describe '#bank_iban' do
      it 'does not allow invalid values', :aggregate_failures do
        expect(model).not_to allow_value('CH93 0076 2011 6238 5295 7').for(:bank_iban)
        expect(model).not_to allow_value('CH93007620116238529577').for(:bank_iban)
        expect(model).not_to allow_value('CH9300762011623852956').for(:bank_iban)
        expect(model).not_to allow_value('XX9300762011623852957').for(:bank_iban)
      end

      it 'allows valid values' do
        expect(model).to allow_value('CH9300762011623852957').for(:bank_iban)
      end
    end
  end

  it do
    expect(described_class.new).to validate_numericality_of(:zdp)
      .only_integer
      .is_less_than(999_999)
      .is_greater_than(25_000)
  end

  describe '#zip_with_city' do
    subject { build(:user, zip: 6274, city: 'RSpec-Hausen').zip_with_city }

    it { is_expected.to eq '6274 RSpec-Hausen' }
  end

  describe '#full_name' do
    subject { build(:user, first_name: 'Peter', last_name: 'Zivi').full_name }

    it { is_expected.to eq 'Peter Zivi' }
  end

  describe '#active?' do
    subject { user.active? }

    let(:user) { create(:user, services: [service]) }
    let(:ending) { (beginning + 1.week).at_end_of_week - 2.days }
    let(:service) { create :service, beginning: beginning, ending: ending }

    context 'when the user\'s currently doing civil service' do
      let(:beginning) { Time.zone.today.at_beginning_of_week }

      it { is_expected.to eq true }
    end

    context 'when the user is not doing civil service' do
      let(:beginning) { Time.zone.today.at_beginning_of_week + 1.week }

      it { is_expected.to eq false }
    end

    context 'when the civil service he\'s currently doing ends today' do
      let(:beginning) { Time.zone.today.at_beginning_of_week - 1.week }
      let(:service) { create :service, :last, beginning: beginning, ending: Time.zone.today }

      it { is_expected.to eq true }
    end
  end

  describe 'JWT payload' do
    let(:payload) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).second }

    context 'when user is admin' do
      let(:user) { build_stubbed :user, :admin }

      it 'has #true isAdmin payload' do
        expect(payload).to include isAdmin: true
      end
    end

    context 'when user is civil servant' do
      let(:user) { create :user }

      it 'has #false isAdmin payload' do
        expect(payload).to include isAdmin: false
      end
    end
  end

  describe '#self.validate_given_params' do
    subject(:errors) { User.validate_given_params(params) }

    let(:params) { { bank_iban: '' } }

    it 'validates only the given fields', :aggregate_failures do
      expect(errors.added?(:bank_iban, :blank)).to eq true
      expect(errors.added?(:bank_iban, :too_short)).to eq true
      expect(errors.to_h.keys).to eq [:bank_iban]
    end
  end
end
