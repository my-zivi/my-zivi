# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject(:model) { described_class.new }

    it 'validates the model correctly', :aggregate_failures do
      expect(model).to validate_numericality_of(:zip).only_integer
      expect(described_class.new).to validate_numericality_of(:zdp)
        .only_integer
        .is_less_than(999_999)
        .is_greater_than(10_000)
    end

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

    describe 'uniqueness validations' do
      subject(:user) { build(:user) }

      it 'validates uniqueness of #email and #zdp', :aggregate_failures do
        %i[email zdp].each do |field|
          expect(user).to validate_uniqueness_of(field).case_insensitive
        end
      end
    end

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

    describe '#legacy_password' do
      context 'when the encrypted password is blank' do
        subject(:model) { described_class.new(encrypted_password: '') }

        it 'requires a legacy password' do
          expect(model).to validate_presence_of(:legacy_password)
        end
      end

      context 'when the encrypted password is present' do
        subject(:model) { described_class.new(encrypted_password: 'pass') }

        it 'does not require a legacy password' do
          expect(model).not_to validate_presence_of(:legacy_password)
        end
      end
    end

    describe '#email' do
      let(:valid_emails) { %w[valid@email.org a@b.c something+other@gmail.com me@subdomain.domain.co.in] }
      let(:invalid_emails) { %w[invalid @hello.com me@.ch 1234 .ch email@email@gmail.com email@invalid+domain.com] }

      it 'allows valid emails', :aggregate_failures do
        valid_emails.each do |valid_email|
          expect(model).to allow_value(valid_email).for :email
        end
      end

      it 'does not allow valid emails', :aggregate_failures do
        invalid_emails.each do |invalid_email|
          expect(model).not_to allow_value(invalid_email).for :email
        end
      end
    end

    context 'when some validations would be invalid' do
      let(:user) { create :user, legacy_password: 'my legacy hash' }

      before do
        user.bank_iban = 'invalid'
        user.health_insurance = ''
        user.save validate: false
      end

      context 'when only password was set/reset' do
        it 'still updates the password' do
          expect { user.update(encrypted_password: 'myencrypted', legacy_password: nil) }.to(
            change(user, :encrypted_password).and(change(user, :legacy_password))
          )
        end
      end

      context 'when something else was changed along with a new password' do
        let(:update_user) { user.update(encrypted_password: 'myencrypted', first_name: 'New name') }

        it 'still validates' do
          expect { update_user }.not_to(change { user.reload.encrypted_password })
        end

        it 'is invalid' do
          update_user
          expect(user.valid?).to eq false
        end
      end

      context 'when some field other than the password was changed' do
        let(:update_user) { user.update(first_name: 'New name', last_name: 'name') }

        it 'does not allow a change', :aggregate_failures do
          expect { update_user }.not_to(change { user.reload.first_name })
        end

        it 'is invalid' do
          update_user
          expect(user.valid?).to eq false
        end
      end
    end
  end

  describe '#zip_with_city' do
    subject { build(:user, zip: 6274, city: 'RSpec-Hausen').zip_with_city }

    it { is_expected.to eq '6274 RSpec-Hausen' }
  end

  describe '#self.strip_iban' do
    it 'removes whitespaces from iban' do
      expect(described_class.strip_iban(' CH56 0483 5012 3456 7800 9')).to eq 'CH5604835012345678009'
    end
  end

  describe '#prettified_bank_iban' do
    subject { build(:user, bank_iban: ugly_iban).prettified_bank_iban }

    let(:ugly_iban) { 'CH5604835012345678009' }
    let(:nice_iban) { 'CH56 0483 5012 3456 7800 9' }

    it { is_expected.to eq nice_iban }
  end

  describe '#full_name' do
    subject { build(:user, first_name: 'Peter', last_name: 'Zivi').full_name }

    it { is_expected.to eq 'Peter Zivi' }
  end

  describe '#active?' do
    subject { user.active? }

    let(:user) { build(:user, services: [service]) }
    let(:ending) { (beginning + 4.weeks).at_end_of_week - 2.days }
    let(:service) { build :service, beginning: beginning, ending: ending }

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
      let(:service) { build :service, :last, beginning: beginning, ending: Time.zone.today }

      it { is_expected.to eq true }
    end
  end

  describe '#active_service' do
    subject(:user) { build(:user, services: services) }

    let(:services) { [past_service, future_service, current_service] }
    let(:now) { Time.zone.today }
    let(:past_service) { build_stubbed :service, beginning: now - 2.months, ending: now - 3.weeks }
    let(:current_service) { build_stubbed :service, beginning: now - 1.month, ending: now + 4.weeks }
    let(:future_service) { build_stubbed :service, beginning: now + 2.months, ending: now + 4.months }

    it 'returns the service which the user is currently doing' do
      expect(user.active_service).to be current_service
    end
  end

  describe '#next_service' do
    subject(:user) { build(:user, services: services) }

    let(:services) { [second_future_service, future_service, current_service] }
    let(:now) { Time.zone.today }
    let(:current_service) { build :service, beginning: now - 1.month, ending: now + 4.weeks }
    let(:future_service) { build :service, beginning: now + 2.months, ending: now + 4.months }
    let(:second_future_service) { build :service, beginning: now + 1.year, ending: now + 1.year + 4.weeks }

    it 'returns the service which the user is currently doing' do
      expect(user.next_service).to be future_service
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
    subject(:errors) { described_class.validate_given_params(params) }

    let(:params) { { bank_iban: '' } }

    it 'validates only the given fields', :aggregate_failures do
      expect(errors.added?(:bank_iban, :blank)).to eq true
      expect(errors.added?(:bank_iban, :too_short)).to eq true
      expect(errors.to_h.keys).to eq [:bank_iban]
    end
  end

  describe '#reset_password' do
    subject(:user) { create :user, legacy_password: 'I am a cool password hash' }

    let(:new_password) { 'even more secure new password' }

    it 'sets legacy password to nil' do
      expect { user.reset_password(new_password, new_password) }.to change(user, :legacy_password).to nil
    end

    it 'updates password' do
      expect { user.reset_password(new_password, new_password) }.to change(user, :password)
    end
  end

  describe '#valid_password?' do
    subject(:authentication) { user.valid_password?(plain_password) }

    let(:plain_password) { '123456' }

    context 'when a legacy password exists' do
      let(:user) { create :user, legacy_password: legacy_password, encrypted_password: '' }
      let(:legacy_password) { '$2a$11$FzM.25l8i27t5qYVNyj8eOblnwgVG2RnU316Jvi5wUieZlqGy.jJC' }

      context 'when the plain password matches hash' do
        let(:plain_password) { '123456' }

        it 'authenticates correctly' do
          expect(authentication).to eq true
        end

        it 'removes the legacy password' do
          expect { authentication }.to change(user, :legacy_password).from(legacy_password).to(nil)
        end

        it 'sets a freshly hashed password' do
          expect { authentication }.to change(user, :encrypted_password).from('')
        end

        context 'when the user has invalid attributes' do
          before do
            user.bank_iban = 'invalid'
            user.save validate: false
          end

          it 'still authenticates correctly' do
            expect(authentication).to eq true
          end
        end
      end

      context 'when the plain password does not match hash' do
        let(:plain_password) { 'invalid password' }

        it 'rejects authentication request' do
          expect(authentication).to eq false
        end

        it 'does not touch #legacy_password or #encrypted_password', :aggregate_failures do
          expect { authentication }.not_to(change(user, :legacy_password))
          expect { authentication }.not_to(change(user, :encrypted_password))
        end
      end
    end

    context 'when no legacy password is present' do
      let(:user) { create :user, legacy_password: nil, encrypted_password: new_hash }
      let(:new_hash) { '$2a$11$wpxRzqV4VXgwAuCCDl8SweyRZ9ZFlDZhWL/a0J/jUcKa02K9lSxta' }

      before do
        allow(user).to receive(:valid_legacy_password?)
        allow(Devise).to receive(:secure_compare)
      end

      it 'does not authenticate using legacy method' do
        authentication
        expect(user).not_to have_received :valid_legacy_password?
      end

      it 'does not touch #legacy_password or #encrypted_password', :aggregate_failures do
        expect { authentication }.not_to(change(user, :legacy_password))
        expect { authentication }.not_to(change(user, :encrypted_password))
      end

      it 'still calls authentication comparision' do
        authentication
        expect(Devise).to have_received(:secure_compare).once
      end
    end
  end
end
