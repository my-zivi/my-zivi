# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Devise::RegistrationsController, type: :request do
  let(:actual_community_password) { 'my cool community password' }

  before do
    allow(ENV).to receive(:[]).with('COMMUNITY_PASSWORD').and_return actual_community_password
    I18n.locale = :de
  end

  after { I18n.locale = I18n.default_locale }

  describe '#create' do
    let(:regional_center) { create :regional_center }
    let(:request) { post user_registration_path(params: { user: params }) }
    let(:params) do
      attributes_for(:user)
        .merge(regional_center_id: regional_center.id, community_password: sent_community_password)
    end

    context 'when community password is correct' do
      let(:sent_community_password) { actual_community_password }

      context 'with valid and allowed parameters' do
        it 'creates a new user' do
          expect { request }.to change(User, :count).by(1)
        end

        it_behaves_like 'renders a successful http status code'
      end

      context 'with some missing parameters' do
        subject { -> { request } }

        let(:params) { attributes_for(:user).slice(:first_name, :last_name) }

        it { is_expected.not_to change(User, :count) }
      end
    end

    context 'with an invalid community password' do
      subject { -> { request } }

      let(:sent_community_password) { 'I am an invalid community password' }

      it { is_expected.not_to change(User, :count) }
      it_behaves_like 'renders a validation error response'
    end
  end

  describe '#validate' do
    subject(:response_json) { parse_response_json(response) }

    let(:request) { get users_validate_path params: { user: params } }

    before { request }

    context 'when a model specific field is invalid' do
      let(:params) { { first_name: '', last_name: '' } }

      it_behaves_like 'renders a validation error response'
      it 'renders only errors of the fields supplied', :aggregate_failures do
        expect(response_json[:errors]).to eq(
          first_name: [I18n.t('errors.messages.blank')],
          last_name: [I18n.t('errors.messages.blank')]
        )
        expect(response_json[:human_readable_descriptions]).to contain_exactly('Vorname muss ausgefüllt werden',
                                                                               'Nachname muss ausgefüllt werden')
      end
    end

    context 'when the community password is wrong' do
      let(:params) { { community_password: 'this is not the actual password' } }

      it_behaves_like 'renders a validation error response'
      it 'renders the correct error', :aggregate_failures do
        expect(response_json[:errors]).to eq(
          community_password: I18n.t('registrations.errors.community_password.not_valid.single')
        )
        expect(response_json[:human_readable_descriptions]).to eq(
          [I18n.t('registrations.errors.community_password.not_valid.full')]
        )
      end
    end

    context 'when all fields are valid' do
      let(:params) { attributes_for(:user).merge(community_password: actual_community_password) }

      it 'renders a No Content header' do
        expect(response).to have_http_status :no_content
      end
    end
  end
end
