# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Devise::RegistrationsController, type: :request do
  describe '#create' do
    context 'with valid and allowed parameters' do
      let(:regional_center) { create :regional_center }
      let(:params) { { user: attributes_for(:user).merge(regional_center_id: regional_center.id) } }
      let(:request) { post user_registration_path(params: params) }

      it 'creates a new user' do
        expect { request }.to change(User, :count).by(1)
      end
    end
  end
end
