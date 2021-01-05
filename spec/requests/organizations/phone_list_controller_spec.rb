# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organizations::PhoneListController, type: :request do
  let(:organization) { create :organization }

  context 'when signed in as an organization administrator' do
    let(:organization_administrator) { create :organization_member, organization: organization }

    let(:first_service_specification) { create :service_specification, organization: organization, name: '1. Spec' }
    let(:second_service_specification) { create :service_specification, organization: organization, name: '2. Spec' }

    let(:first_civil_servant) { create :civil_servant, :full, first_name: 'Hanspeter', last_name: 'Hugentobler' }
    let(:second_civil_servant) { create :civil_servant, :full }
    let(:third_civil_servant) do
      create :civil_servant, :with_service, :with_user,
             first_name: 'Not', last_name: 'Here',
             service_attributes: {
               beginning: '2020-08-03',
               ending: '2020-09-11',
               service_specification: first_service_specification
             },
             service_traits: [
               :civil_servant_agreement_pending
             ]
    end

    let(:first_service) do
      create :service,
             civil_servant: first_civil_servant,
             beginning: '2020-08-03',
             ending: '2020-09-11',
             service_specification: first_service_specification
    end
    let(:second_service) do
      create :service,
             civil_servant: first_civil_servant,
             beginning: '2020-09-14',
             ending: '2020-10-16',
             service_specification: second_service_specification
    end
    let(:third_service) do
      create :service,
             civil_servant: second_civil_servant,
             beginning: '2020-08-03',
             ending: '2020-09-11',
             service_specification: second_service_specification
    end

    before do
      first_service
      second_service
      third_service
      sign_in organization_administrator.user
    end

    around do |spec|
      travel_to(Date.parse('2020-09-08')) { spec.run }
    end

    describe '#index' do
      context 'when format is html' do
        before { get organizations_phone_list_path(params: params) }

        let(:params) { {} }

        context 'when there is no filter' do
          it 'returns expected data' do
            expect(response).to have_http_status(:success)
            expect(response.body).to include I18n.t('organizations.phone_list.index.title.without_filter')
            expect(response.body.scan(/#{first_service_specification.name}/).size).to eq 1
            expect(response.body.scan(/#{second_service_specification.name}/).size).to eq 1
            expect(response.body.scan(/#{first_civil_servant.full_name}/).size).to eq 1
            expect(response.body.scan(/#{second_civil_servant.full_name}/).size).to eq 1
          end

          it 'does not return agreement services' do
            expect(response).to have_http_status(:success)
            expect(response.body.scan(/#{third_civil_servant.full_name}/).size).to be_zero
          end
        end

        context 'when there is date range filter' do
          let(:params) do
            {
              filters: {
                range: range
              }
            }
          end
          let(:range) { '01.09.2020 bis 30.09.2020' }

          it 'returns expected data' do
            expect(response).to have_http_status(:success)
            expect(response.body).to include I18n.t('organizations.phone_list.index.title.with_filter', range: range)
            expect(response.body.scan(/#{first_service_specification.name}/).size).to eq 1
            expect(response.body.scan(/#{second_service_specification.name}/).size).to eq 1
            expect(response.body.scan(/#{first_civil_servant.full_name}/).size).to eq 2
            expect(response.body.scan(/#{second_civil_servant.full_name}/).size).to eq 1
          end

          context 'when range excludes the second service' do
            let(:range) { '07.09.2020 bis 10.09.2020' }

            it 'does not render the second service' do
              expect(response.body).to include I18n.t('organizations.phone_list.index.title.with_filter', range: range)
              expect(response.body.scan(/#{first_service_specification.name}/).size).to eq 1
              expect(response.body.scan(/#{second_service_specification.name}/).size).to eq 1
              expect(response.body.scan(/#{first_civil_servant.full_name}/).size).to eq 1
              expect(response.body.scan(/#{second_civil_servant.full_name}/).size).to eq 1
            end
          end

          context 'when range excludes all services' do
            let(:range) { '07.01.2020 bis 10.01.2020' }

            it 'does render the placeholder' do
              expect(response.body).to include I18n.t('organizations.phone_list.index.empty-result')
            end
          end
        end
      end

      context 'when format is pdf' do
        let(:params) { {} }

        before { get organizations_phone_list_path(format: :pdf, params: params) }

        context 'when there is no filter' do
          it 'returns correct response' do
            expect(response).to have_http_status(:success)
            expect(response.content_type).to eq 'application/pdf'
            expect(response.content_length).to be_positive
          end
        end

        context 'when there is date range filter' do
          let(:params) do
            {
              filters: {
                beginning: '01.09.2020',
                ending: '30.09.2020'
              }
            }
          end

          it 'returns correct response' do
            expect(response).to have_http_status(:success)
            expect(response.content_type).to eq 'application/pdf'
            expect(response.content_length).to be_positive
          end
        end
      end
    end
  end

  context 'when signed in as a civil servant' do
    let(:civil_servant) { create :civil_servant, :full }

    before { sign_in civil_servant.user }

    describe '#index' do
      let(:perform_request) { get organizations_phone_list_path }

      before { perform_request }

      it_behaves_like 'unauthorized request'
    end
  end

  context 'when no one is signed in' do
    describe '#index' do
      let(:perform_request) { get organizations_phone_list_path }

      before { perform_request }

      it_behaves_like 'unauthenticated request'
    end
  end
end
