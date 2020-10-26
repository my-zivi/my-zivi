# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organizations::ServiceAgreementsController, type: :request do
  describe '#index', :without_bullet do
    let(:perform_request) { get organizations_service_agreements_path }
    let(:organization) { create :organization }
    let(:service_specification) { create :service_specification, organization: organization }

    let(:brigitte) { create(:civil_servant, :with_service, :full, first_name: 'Brigitte') }
    let(:peter) { create(:civil_servant, :with_service, :full, first_name: 'Peter') }
    let(:maria) { create(:civil_servant, :full, first_name: 'Maria') }
    let(:paul) { create(:civil_servant, :full, :with_service, first_name: 'Paul') }

    let(:brigitte_service) { brigitte.services.first }
    let(:peter_service) { peter.services.first }
    let(:maria_service) { maria.services.first }
    let(:paul_service) { paul.services.first }

    before do
      create(:service,
             civil_servant: maria,
             service_specification: service_specification,
             beginning: '2020-01-06',
             ending: '2020-01-31',
             civil_servant_agreed: false,
             civil_servant_agreed_on: nil,
             organization_agreed: true,
             organization_agreed_on: '2020-01-01')
    end

    context 'when a organization administrator is signed in' do
      let(:organization_administrator) { create :organization_member, organization: organization }

      before { sign_in organization_administrator.user }

      it 'successfully fetches a list of service agreements in the organization' do
        perform_request
        expect(response).to have_http_status(:success)
        expect(response.body).to include 'Maria'
        expect(response.body).not_to include 'Brigitte', 'Peter', 'Paul'
      end
    end

    context 'when a civil servant is signed in' do
      let(:civil_servant) { create :civil_servant, :full }

      before { sign_in civil_servant.user }

      it_behaves_like 'unauthorized request' do
        before { perform_request }
      end
    end

    context 'when nobody is signed in' do
      before { perform_request }

      it_behaves_like 'unauthenticated request'
    end
  end

  describe '#destroy' do
    let(:perform_request) { delete organizations_service_agreement_path(maria_service) }
    let(:organization) { create :organization }
    let(:service_specification) { create :service_specification, organization: organization }

    let(:maria) { create(:civil_servant, :full, first_name: 'Maria') }
    let(:maria_service) { maria.services.first }

    before do
      create(:service,
             civil_servant: maria,
             service_specification: service_specification,
             beginning: '2020-01-06',
             ending: '2020-01-31',
             civil_servant_agreed: false,
             civil_servant_agreed_on: nil,
             organization_agreed: true,
             organization_agreed_on: '2020-01-01')
    end

    context 'when a organization administrator is signed in' do
      let(:organization_administrator) { create :organization_member, organization: organization }

      before { sign_in organization_administrator.user }

      it 'successfully destroy the service agreement' do
        expect { perform_request }.to change(Service, :count).by(-1)
        expect(flash[:notice]).to eq I18n.t('organizations.service_agreements.destroy.successful_destroy')
        expect(response).to redirect_to organizations_service_agreements_path
      end

      context 'when the org admin is from another organization' do
        let(:organization_administrator) { create :organization_member }

        before { sign_in organization_administrator.user }

        it 'does not destroy the service agreement' do
          expect { perform_request }.not_to change(Service, :count)
        end

        it_behaves_like 'unauthorized request' do
          before { perform_request }
        end
      end

      context 'when the service already has expense sheets' do
        before { ExpenseSheetGenerator.new(maria_service).create_expense_sheets }

        it 'does not destroy the service agreement' do
          expect { perform_request }.not_to change(Service, :count)
          expect(flash[:error]).to eq I18n.t('organizations.service_agreements.destroy.erroneous_destroy')
          expect(response).to redirect_to organizations_service_agreements_path
        end
      end
    end

    context 'when a civil servant is signed in' do
      let(:civil_servant) { create :civil_servant, :full }

      before { sign_in civil_servant.user }

      it_behaves_like 'unauthorized request' do
        before { perform_request }
      end
    end

    context 'when nobody is signed in' do
      before { perform_request }

      it_behaves_like 'unauthenticated request'
    end
  end

  describe '#search' do
    let(:perform_request) do
      get organizations_service_agreement_civil_servant_search_path(term: search_term, format: :json)
    end
    let(:organization) { create :organization }
    let(:service_specification) { create :service_specification, organization: organization }

    let(:brigitte) { create(:civil_servant, :full, :with_service, first_name: 'Brigitte') }
    let(:peter) { create(:civil_servant, :full, :with_service, first_name: 'Peter') }
    let(:paul) { create(:civil_servant, :full, :with_service, first_name: 'Paul') }
    let(:maria) { create(:civil_servant, :full, first_name: 'Maria') }

    let(:brigitte_service) { brigitte.services.first }
    let(:peter_service) { peter.services.first }
    let(:paul_service) { paul.services.first }
    let(:maria_service) { maria.services.first }

    let(:search_result) { CivilServantSearch.call(search_term, organization) }
    let(:search_term) { '' }

    before do
      create(:service,
             civil_servant: maria,
             service_specification: service_specification,
             beginning: '2020-01-06',
             ending: '2020-01-31',
             civil_servant_agreed: false,
             civil_servant_agreed_on: nil,
             organization_agreed: true,
             organization_agreed_on: '2020-01-01')
    end

    context 'when a organization administrator is signed in' do
      let(:organization_administrator) { create :organization_member, organization: organization }

      before { sign_in organization_administrator.user }

      it 'successfully fetches the search results' do
        perform_request
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body, symbolize_names: true)).to eq({ results: search_result })
        expect(response.body).to include 'Maria'
        expect(response.body).not_to include 'Brigitte', 'Peter', 'Paul'
      end

      context 'when there is a search term' do
        let(:search_term) { 'Brigitte' }

        it 'successfully fetches the search results' do
          perform_request
          expect(response).to have_http_status(:success)
          expect(JSON.parse(response.body, symbolize_names: true)).to eq({ results: search_result })
          expect(response.body).not_to include 'Brigitte', 'Peter', 'Paul', 'Maria'
        end
      end
    end

    context 'when a civil servant is signed in' do
      let(:civil_servant) { create :civil_servant, :full }

      before { sign_in civil_servant.user }

      it_behaves_like 'unauthorized json request' do
        before { perform_request }
      end
    end

    context 'when nobody is signed in' do
      before { perform_request }

      it_behaves_like 'unauthenticated json request' do
        before { perform_request }
      end
    end
  end

  describe '#new' do
    let(:perform_request) { get organizations_service_agreements_new_path(params: request_params) }
    let(:organization) { create :organization }
    let(:service_specification) { create :service_specification, organization: organization }

    let(:maria) { create(:civil_servant, :full, first_name: 'Maria') }

    let(:request_params) do
      {
        service_agreement: {
          civil_servant_attributes: {
            user_attributes: {
              email: '-1'
            }
          }
        }
      }
    end

    context 'when a organization administrator is signed in' do
      let(:organization_administrator) { create :organization_member, organization: organization }

      before do
        sign_in organization_administrator.user
        perform_request
      end

      context 'when there is no civi set' do
        it 'successfully renders the new service agreement form' do
          expect(response).to render_template(:new)
        end
      end

      context 'when there is a civi set' do
        let(:request_params) do
          {
            service_agreement: {
              civil_servant_attributes: {
                user_attributes: {
                  email: maria.user.email
                }
              }
            }
          }
        end

        it 'successfully renders the new service agreement form' do
          expect(response).to render_template(:new)
        end

      end
    end

    context 'when a civil servant is signed in' do
      let(:civil_servant) { create :civil_servant, :full }

      before { sign_in civil_servant.user }

      it_behaves_like 'unauthorized request' do
        before { perform_request }
      end
    end

    context 'when nobody is signed in' do
      before { perform_request }

      it_behaves_like 'unauthenticated request'
    end
  end

  describe '#create' do
    let(:perform_request) { post(organizations_service_agreements_path, params: params) }
    let(:params) { { service_agreement: service_agreement_params } }
    let(:organization) { create :organization }

    let(:civil_servant) { create(:civil_servant, :full) }
    let(:service_agreement_params) do
      attributes_for(:service, :civil_servant_agreement_pending, :unconfirmed, :future).merge(
        civil_servant_attributes: {
          user_attributes: {
            email: civil_servant.user.email
          }
        }
      )
    end

    let(:created_service_agreement) { Service.order(:created_at).last }

    context 'when a organization administrator is signed in' do
      let(:organization_administrator) { create :organization_member, organization: organization }

      before do
        sign_in organization_administrator.user
        perform_request
      end

      context 'with valid parameters' do
        it 'creates a new service agreement and redirects back to the service specifications list' do
          expect { perform_request }.to change(Service, :count).by(1)
          expect(response).to redirect_to(organizations_service_agreements_path)

          # updated_attributes = created_service_agreement.slice(service_agreement_params.keys).symbolize_keys
          # expect(updated_attributes).to eq service_agreement_params
        end
      end

      context 'with invalid parameters' do
        let(:service_agreement_params) do
          attributes_for(:service).merge(
            beginning: nil
          )
        end

        let(:expected_error_messages) do
          %i[civil_servant beginning].map do |attribute_name|
            blank = I18n.t('errors.messages.blank')
            "#{I18n.t(attribute_name, scope: %i[activerecord attributes service_agreement])} #{blank}"
          end
        end

        it 'does not create a new service agreement and renders an error' do
          expect { perform_request }.not_to change(Service, :count)
          expect(response).to be_successful
          expect(response).to render_template 'organizations/service_agreements/new'
          expect(response.body).to include(*expected_error_messages)
        end
      end


    end

    context 'when a civil servant is signed in' do
      let(:civil_servant) { create :civil_servant, :full }

      before { sign_in civil_servant.user }

      it_behaves_like 'unauthorized request' do
        before { perform_request }
      end
    end

    context 'when nobody is signed in' do
      before { perform_request }

      it_behaves_like 'unauthenticated request'
    end
  end
end
