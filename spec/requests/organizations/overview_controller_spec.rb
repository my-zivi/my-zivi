# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organizations::OverviewController, type: :request do
  let(:organization) { create(:organization, :with_admin) }

  describe '#index' do
    let(:perform_request) { get organizations_path }

    context 'when signed in as an organization administrator' do
      let(:organization_administrator) { create(:organization_member, organization: organization) }

      let(:service_specification) { create(:service_specification, organization: organization) }

      before do
        create(:service, :civil_servant_agreement_pending,
               service_specification: service_specification,
               civil_servant: create(:civil_servant, :full, first_name: 'Peter', last_name: 'Paul'))
        create(:service,
               service_specification: service_specification,
               confirmation_date: nil,
               civil_servant: create(:civil_servant, :full, first_name: 'Hans', last_name: 'Maria'))
        create(:service,
               service_specification: service_specification,
               civil_servant: create(:civil_servant, :full, first_name: 'Philip', last_name: 'Fehr'))

        sign_in organization_administrator.user
        perform_request
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
        expect(response.body).to include 'Peter Paul', 'Hans Maria'
        expect(response.body).not_to include 'Philipp Fehr'
      end
    end

    it_behaves_like 'admin subscription route only'
  end
end
