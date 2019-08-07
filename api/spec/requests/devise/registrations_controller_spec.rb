# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Devise::RegistrationsController, type: :request do
  describe '#create' do
    let(:actual_community_password) { 'my cool community password' }
    let(:regional_center) { create :regional_center }
    let(:request) { post user_registration_path(params: { user: params }) }
    let(:params) do
      attributes_for(:user)
        .merge(regional_center_id: regional_center.id, community_password: sent_community_password)
    end

    before do
      allow(ENV).to receive(:[]).with('COMMUNITY_PASSWORD').and_return actual_community_password
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
end
