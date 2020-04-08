# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::ServiceCalculatorController, type: :request do
  subject(:json_response) { parse_response_json(response) }

  let(:beginning) { '2018-01-01' }
  let(:service_days_request) { get calculate_service_days_v1_services_path(beginning: beginning, ending: ending) }
  let(:ending) { '2018-01-26' }
  let(:ending_request) { get calculate_ending_v1_services_path(beginning: beginning, service_days: service_days) }
  let(:service_days) { 26 }

  context 'when the user is signed in' do
    let(:civil_servant) { create :civil_servant }

    before { sign_in civil_servant.user }

    describe '#calculate_service_days' do
      before { service_days_request }

      context 'with valid ending date' do
        it 'returns the correct result' do
          expect(json_response).to eq(result: 26)
        end
      end

      context 'with ending on weekend' do
        let(:ending) { '2018-01-27' }

        it 'returns the correct error' do
          expect(json_response).to eq(result: 27)
        end
      end
    end

    describe '#calculate_ending' do
      before { ending_request }

      context 'with valid service days' do
        it 'returns the correct result' do
          expect(json_response).to eq(result: '2018-01-26')
        end
      end

      context 'with negative service days' do
        let(:service_days) { 0 }

        it 'returns the correct error' do
          expect(json_response).to eq(error: I18n.t('service_calculator.invalid_required_service_days'))
        end
      end
    end
  end

  context 'when no user is signed in' do
    describe '#calculate_service_days' do
      it_behaves_like 'login protected resource' do
        let(:request) { service_days_request }
      end
    end

    describe '#calculate_ending' do
      it_behaves_like 'login protected resource' do
        let(:request) { ending_request }
      end
    end
  end
end
