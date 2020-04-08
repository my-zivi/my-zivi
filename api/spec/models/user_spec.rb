# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject(:model) { described_class.new }

    it_behaves_like 'validates presence of required fields', %i[email]

    describe 'uniqueness validations' do
      subject(:user) { build(:user) }

      it 'validates uniqueness of #email' do
        expect(user).to validate_uniqueness_of(:email).case_insensitive
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

    let(:params) { { email: '' } }

    it 'validates only the given fields', :aggregate_failures do
      expect(errors.added?(:email, :blank)).to eq true
      expect(errors.added?(:email, :invalid, value: '')).to eq true
      expect(errors.to_h.keys).to eq [:email]
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

    let(:user) { create :user, encrypted_password: new_hash }
    let(:new_hash) { '$2a$11$wpxRzqV4VXgwAuCCDl8SweyRZ9ZFlDZhWL/a0J/jUcKa02K9lSxta' }

    before do
      allow(Devise).to receive(:secure_compare)
    end

    it 'does not touch #legacy_password or #encrypted_password', :aggregate_failures do
      expect { authentication }.not_to(change(user, :encrypted_password))
    end

    it 'still calls authentication comparision' do
      authentication
      expect(Devise).to have_received(:secure_compare).once
    end
  end
end
