# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::RegionalCentersController, type: :request do
  context 'when a user is signed in' do
    describe '#index' do
      subject { response }

      let!(:regional_center) { create :regional_center }
      let(:user) { create :user, regional_center: regional_center }
      let(:response_json) { parse_response_json(response) }

      before do
        sign_in user

        get v1_regional_centers_path
      end

      it { is_expected.to be_successful }

      it 'returns one regional center' do
        expect(response_json.length).to be 1
      end

      it 'has all attributes' do
        expect(response_json.first).to include(
          id: regional_center.id,
          name: regional_center.name,
          address: regional_center.address,
          short_name: regional_center.short_name
        )
      end
    end
  end

  context 'when user is not signed in' do
    describe '#index' do
      it_behaves_like 'login protected resource' do
        let(:request) { get v1_regional_centers_path }
      end
    end
  end
end
