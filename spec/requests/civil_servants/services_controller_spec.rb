# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CivilServants::ServicesController, type: :request do
  describe '#index' do
    let(:perform_request) { get civil_servants_services_path }

    context 'when a civil servant is signed in' do
      let(:perform_request) { get civil_servants_services_path, params: { filters: filters } }
      let(:civil_servant) { create :civil_servant, :full }
      let!(:past_service) do
        complement_service(
          create(:service, :past, civil_servant: civil_servant),
          specification_params: { name: 'Past Service Specification', location: 'past location' },
          organization_params: { name: 'Past Organization' }
        )
      end
      let!(:active_service) do
        complement_service(
          create(:service, :active, civil_servant: civil_servant),
          specification_params: { name: 'Active Service Specification', location: 'active location' },
          organization_params: { name: 'Active Organization' }
        )
      end
      let!(:future_service) do
        complement_service(
          create(:service, :future, civil_servant: civil_servant),
          specification_params: { name: 'Future Service Specification', location: 'future location' },
          organization_params: { name: 'Future Organization' }
        )
      end
      let(:expected_services) { [active_service, future_service] }
      let(:unexpected_services) { [past_service] }
      let(:filters) { { show_all: show_all } }
      let(:show_all) { false }
      let(:expected_strings) do
        expected_service_strings +
          [
            I18n.t('civil_servants.services.index.services'),
            I18n.t('civil_servants.services.index.show_past_services')
          ]
      end
      let(:expected_service_strings) do
        expected_services.flat_map do |service|
          service_spec = service.service_specification
          [
            I18n.t('civil_servants.services.service_short_info_row.service_with', org_name: service.organization.name),
            service_spec.name,
            service_spec.location,
            I18n.t('civil_servants.services.service_short_info_row.service_duration',
                   beginning_date: I18n.l(service.beginning), ending_date: I18n.l(service.ending)),
            I18n.t(service.confirmation_date.present?,
                   scope: %i[civil_servants services service_short_info_row service_confirmed])
          ]
        end
      end
      let(:unexpected_service_strings) do
        unexpected_services.flat_map do |service|
          service_spec = service.service_specification
          [
            I18n.t('civil_servants.services.service_short_info_row.service_with', org_name: service.organization.name),
            service_spec.name,
            service_spec.location,
            I18n.t('civil_servants.services.service_short_info_row.service_duration',
                   beginning_date: I18n.l(service.beginning), ending_date: I18n.l(service.ending))
          ]
        end
      end

      before { sign_in civil_servant.user }

      it 'returns http success' do
        perform_request
        expect(response).to have_http_status(:success)
      end

      context 'when the show_all filter is off' do
        it 'renders the expected strings' do
          perform_request
          expect(response.body).to include(*expected_strings.map(&:to_s))
          expect(response.body).not_to include(*unexpected_service_strings.map(&:to_s))
        end
      end

      context 'when the show_all filter is on' do
        let(:show_all) { true }
        let(:expected_services) { [past_service, active_service, future_service] }
        let(:unexpected_services) { [] }

        it 'renders the expected strings' do
          perform_request
          expect(response.body).to include(*expected_strings.map(&:to_s))
          expect(response.body).not_to include(*unexpected_service_strings.map(&:to_s))
        end
      end
    end

    context 'when an administrator is signed in' do
      let(:organization_admin) { create :organization_member }

      before do
        sign_in organization_admin.user
        perform_request
      end

      it_behaves_like 'unauthorized request'
    end

    context 'when no user is signed in' do
      before { perform_request }

      it_behaves_like 'unauthenticated request'
    end
  end

  describe '#show' do
    let(:perform_request) { get civil_servants_service_path(service) }

    let(:service) { create :service }

    context 'when a civil servant is signed in' do
      let(:civil_servant) { service.civil_servant }

      before { sign_in civil_servant.user }

      it 'returns http success' do
        perform_request
        expect(response).to have_http_status(:success)
      end
    end

    context 'when an administrator is signed in' do
      let(:organization_admin) { create :organization_member }

      before do
        sign_in organization_admin.user
        perform_request
      end

      it_behaves_like 'unauthorized request'
    end

    context 'when no user is signed in' do
      before { perform_request }

      it_behaves_like 'unauthenticated request'
    end
  end
end
