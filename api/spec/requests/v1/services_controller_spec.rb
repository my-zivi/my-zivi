# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::ServicesController, type: :request do
  context 'when user is signed in' do
    let(:civil_servant) { create :civil_servant }

    before { sign_in civil_servant.user }

    describe '#index' do
      subject(:json_response) { parse_response_json(response) }

      let(:request) { get v1_services_path }

      before do
        create(:service, beginning: '2018-11-05', ending: '2018-11-30', civil_servant: user)
        create(:service, beginning: '2018-12-03', ending: '2018-12-28', civil_servant: user)
      end

      context 'when user is not admin' do
        it_behaves_like 'admin protected resource'
      end
    end

    describe '#show' do
      context 'when the json format is requested' do
        let(:request) { get v1_service_path service, format: :json }

        before { request }

        context 'when the user has permission to view its own resource' do
          let(:service) { create :service, civil_servant: user }
          let(:expected_response) do
            extract_to_json(service, :id, :user_id, :service_specification_identification_number,
                            :beginning, :ending, :confirmation_date, :eligible_paid_vacation_days,
                            :service_type, :first_swo_service, :long_service,
                            :probation_service)
          end

          it_behaves_like 'renders a successful http status code'

          it 'renders the correct response' do
            expect(parse_response_json(response)).to include(expected_response)
          end
        end

        context 'when the requested resource does not exist' do
          it_behaves_like 'renders a not found error response' do
            let(:request) { get v1_service_path(-2) }
          end
        end

        context 'when a non-admin user requests a service which is not his own' do
          let(:service) { create :service, civil_servant: create(:civil_servant) }

          it_behaves_like 'admin protected resource'
        end
      end

      context 'when the pdf format is requested' do
        let(:request) { get v1_service_path service, format: :pdf, params: { token: token } }
        let(:token) { generate_jwt_token_for_user(user) }

        before { request }

        context 'when the user has permission to view its own resource' do
          let(:service) { create :service, civil_servant: user }
          let(:expected_response) do
            extract_to_json(service, :id, :user_id, :service_specification_identification_number,
                            :beginning, :ending, :confirmation_date, :eligible_paid_vacation_days,
                            :service_type, :first_swo_service, :long_service,
                            :probation_service)
          end

          it_behaves_like 'renders a successful http status code'
        end

        context 'when the requested resource does not exist' do
          it_behaves_like 'renders a not found error response' do
            let(:request) { get v1_service_path(-2) }
          end
        end

        context 'when a non-admin user requests a service which is not his own' do
          let(:service) { create :service, civil_servant: create(:civil_servant) }

          it { expect(response).to have_http_status(:unauthorized) }
        end
      end
    end

    describe '#create' do
      subject { -> { post_request } }

      let(:service_specification) { create :service_specification }
      let(:post_request) { post v1_services_path(service: params) }

      let(:valid_params) do
        attributes_for(:service, :unconfirmed)
          .merge(
            service_specification_id: service_specification.id,
            user_id: user.id
          )
      end

      context 'when params are valid' do
        let(:params) { valid_params }

        let(:expected_returned_attributes) do
          %i[
            user_id
            beginning
            ending
            confirmation_date
            eligible_paid_vacation_days
            service_type
            first_swo_service
            long_service
            probation_service
          ]
        end

        it_behaves_like 'renders a successful http status code' do
          let(:request) { post_request }
        end

        it 'creates a new Service' do
          expect { post_request }.to change(Service, :count).by(1)
        end

        it 'returns the created service' do
          post_request
          expect(parse_response_json(response)).to include(
            params.slice(*expected_returned_attributes).merge(
              service_specification: {
                identification_number: Service.last.identification_number,
                name: Service.last.service_specification.name
              }
            ).transform_values { |value| value.is_a?(Symbol) ? value.to_s : value }
          )
        end

        context 'when a non-admin user tries to create a service for another user' do
          let(:other_user) { create :civil_servant }
          let(:params) { valid_params.merge(user_id: other_user.id) }

          it 'ignores the other user\'s id' do
            expect { post_request }.not_to(change { other_user.reload.services.count })
          end

          it 'does create the service in the name of the logged in user' do
            expect { post_request }.to(change { user.reload.services.count }.by(1))
          end
        end

        context 'when a non-admin user tries to create a service with a confirmation date' do
          let(:params) { valid_params.merge(confirmation_date: '2018-11-01') }

          it 'ignores confirmation date' do
            post_request
            expect(parse_response_json(response)[:confirmation_date]).to eq nil
          end
        end
      end

      context 'when params are invalid' do
        let(:params) do
          valid_params.merge(
            beginning: Time.zone.today.end_of_week.to_s, ending: 'I am invalid'
          )
        end

        it 'does not create a new Service' do
          expect { request }.to change(Service, :count).by(0)
        end

        describe 'returned error' do
          it_behaves_like 'renders a validation error response' do
            let(:request) { post_request }
          end

          it 'renders all validation errors' do
            post_request
            expect(parse_response_json(response)[:errors]).to include(
              beginning: be_an_instance_of(Array),
              ending: be_an_instance_of(Array)
            )
          end
        end
      end
    end

    describe '#update' do
      let!(:service) { create :service, :unconfirmed, civil_servant: user }
      let(:put_request) { put v1_service_path(service, params: { service: params }) }

      context 'with valid params' do
        let(:new_service_date) { service.beginning - 7.days }
        let(:new_confirmation_date) { service.beginning - 8.days }
        let(:params) { { beginning: new_service_date, confirmation_date: new_confirmation_date } }
        let(:expected_attributes) do
          extract_to_json(service, :id, :user_id, :service_specification_identification_number, :beginning,
                          :ending, :confirmation_date, :eligible_paid_vacation_days,
                          :service_type, :first_swo_service, :long_service,
                          :probation_service)
        end

        context 'when a non-admin user updates their own service' do
          it 'updates the service' do
            expect { put_request }.to(change { service.reload.beginning }.to(new_service_date))
          end

          it_behaves_like 'renders a successful http status code' do
            let(:request) { put_request }
          end

          it 'returns the updated service' do
            put_request
            expect(parse_response_json(response)).to include(expected_attributes)
          end

          it 'ignores confirmation date', :aggregate_failures do
            expect { put_request }.not_to(change { service.reload.confirmation_date })
            expect(parse_response_json(response)[:confirmation_date]).to eq(nil)
          end
        end

        context 'when a non-admin user updates their own confirmed service' do
          let!(:service) { create :service, civil_servant: user }

          it_behaves_like 'admin protected resource' do
            let(:request) { put_request }
          end

          it 'does not update the service' do
            expect { put_request }.not_to(change { service.reload.confirmation_date })
          end
        end

        context 'when a non-admin user tries to update other\'s service' do
          let!(:service) { create :service, :unconfirmed, civil_servant: create(:civil_servant) }

          it_behaves_like 'admin protected resource' do
            let(:request) { put_request }
          end

          it 'does not update the service' do
            expect { put_request }.not_to(change { service.reload.confirmation_date })
          end
        end
      end

      context 'with invalid params' do
        let(:civil_servant) { create :civil_servant, :admin }
        let(:params) { { ending: 'invalid' } }

        it_behaves_like 'renders a validation error response' do
          let(:request) { put_request }
        end

        it 'renders all validation errors' do
          put_request
          expect(parse_response_json(response)[:errors]).to include(
            ending: be_an_instance_of(Array)
          )
        end
      end

      context 'when the requested resource does not exist' do
        it_behaves_like 'renders a not found error response' do
          let(:request) { put v1_service_path(-2) }
        end
      end
    end

    describe '#destroy' do
      let(:delete_request) { delete v1_service_path service }
      let(:service) { create :service, civil_servant: user }

      before { service }

      context 'when the user deletes his own service' do
        it 'does delete the Service' do
          expect { delete_request }.to change(Service, :count).by(-1)
        end

        it_behaves_like 'renders a successful http status code' do
          let(:request) { delete_request }
        end
      end

      context 'when a non-admin user tries to delete a foreign service' do
        let(:service) { create :service, civil_servant: create(:civil_servant) }

        it 'does not delete the Service' do
          expect { delete_request }.not_to change(Service, :count)
        end

        it_behaves_like 'admin protected resource' do
          let(:request) { delete_request }
        end
      end

      context 'when the requested resource does not exist' do
        let(:request) { delete v1_service_path(-1) }

        it_behaves_like 'renders a not found error response'
      end
    end

    describe '#confirm' do
      let(:confirm_request) { put service_confirm_v1_service_path service }
      let(:service) { create :service, :unconfirmed, civil_servant: user }

      before { service }

      context 'when the user confirms his own service' do
        it 'does not update the confirmation_date the Service' do
          expect { request }.not_to(change { service.reload.confirmation_date })
        end

        it_behaves_like 'admin protected resource' do
          let(:request) { confirm_request }
        end
      end

      context 'when a non-admin user tries to confirm a foreign service' do
        let(:service) { create :service, :unconfirmed, civil_servant: create(:civil_servant) }

        it 'does not update the confirmation_date the Service' do
          expect { request }.not_to(change { service.reload.confirmation_date })
        end

        it_behaves_like 'admin protected resource' do
          let(:request) { confirm_request }
        end
      end
    end
  end

  context 'when admin is signed in' do
    let(:civil_servant) { create :civil_servant, :admin }

    before { sign_in civil_servant.user }

    describe '#index' do
      subject(:json_response) { parse_response_json(response) }

      let!(:services) do
        [
          create(:service, beginning: '2018-10-01', ending: '2018-11-02', civil_servant: user),
          create(:service, beginning: '2018-11-05', ending: '2018-12-28', civil_servant: user)
        ]
      end
      let(:request) { get v1_services_path }
      let(:first_service_json) do
        extract_to_json(
          services.first,
          :beginning, :ending, :confirmation_date, :id, :service_specification_id, :service_type
        )
          .merge(service_specification: extract_to_json(services.first.service_specification,
                                                        :name, :short_name, :identification_number))
          .merge(civil_servant: extract_to_json(services.first.civil_servant, :id, :first_name, :last_name, :zdp))
      end

      let(:second_service_json) do
        extract_to_json(
          services.second,
          :beginning, :ending, :confirmation_date, :id, :service_specification_id, :service_type
        )
          .merge(service_specification: extract_to_json(services.second.service_specification,
                                                        :name, :short_name, :identification_number))
          .merge(civil_servant: extract_to_json(services.second.civil_servant, :id, :first_name, :last_name, :zdp))
      end

      context 'when the user is admin' do
        let(:civil_servant) { create :civil_servant, :admin }

        before do
          create :service, beginning: '2019-05-27', ending: '2019-06-28', civil_servant: user
          request
        end

        it_behaves_like 'renders a successful http status code'

        it 'returns the correct data', :aggregate_failures do
          expect(json_response.length).to eq 3
          expect(json_response).to include(first_service_json)
          expect(json_response).to include(second_service_json)
        end

        context 'with a year filter' do
          let(:request) { get v1_services_path(params: { year: 2018 }) }

          it 'only returns services of year 2018' do
            expect(json_response.length).to eq 2
            expect(json_response).to include(first_service_json)
            expect(json_response).to include(second_service_json)
          end
        end
      end
    end

    describe '#show' do
      context 'when the json format is requested' do
        let(:request) { get v1_service_path service, format: :json }

        before { request }

        context 'when the user is admin' do
          let(:service) { create :service, civil_servant: create(:civil_servant) }

          it 'is able to load services pdf from another user' do
            expect(response).to be_successful
          end
        end
      end

      context 'when the pdf format is requested' do
        let(:request) { get v1_service_path service, format: :pdf, params: { token: token } }
        let(:token) { generate_jwt_token_for_user(user) }

        before { request }

        context 'when the user is admin' do
          let(:service) { create :service, civil_servant: create(:civil_servant) }

          it 'is able to view services from different people' do
            expect(response).to be_successful
          end

          it 'returns a content type pdf' do
            expect(response.headers['Content-Type']).to include 'pdf'
          end
        end
      end
    end

    describe '#create' do
      subject { -> { post_request } }

      let(:service_specification) { create :service_specification }
      let(:post_request) { post v1_services_path(service: params) }

      let(:valid_params) do
        attributes_for(:service, :unconfirmed, first_swo_service: false)
          .merge(
            service_specification_id: service_specification.id,
            user_id: user.id
          )
      end

      context 'when a admin user tries to create a service for another user with valid params' do
        let(:civil_servant) { create :civil_servant, :admin }
        let(:other_user) { create :civil_servant }
        let(:params) { valid_params.merge(user_id: other_user.id) }

        it 'creates the service in the name of the other user' do
          expect { post_request }.to(change { other_user.reload.services.count }.by(1))
        end

        it 'does not create the service in the name of the logged in user' do
          expect { post_request }.not_to(change { user.reload.services.count })
        end
      end
    end

    describe '#update' do
      let!(:service) { create :service, :unconfirmed, civil_servant: user }
      let(:put_request) { put v1_service_path(service, params: { service: params }) }

      context 'with valid params' do
        let(:new_service_date) { service.beginning - 7.days }
        let(:new_confirmation_date) { service.beginning - 8.days }
        let(:expected_attributes) do
          extract_to_json(service, :id, :user_id, :service_specification_identification_number, :beginning,
                          :ending, :confirmation_date, :eligible_paid_vacation_days,
                          :service_type, :first_swo_service, :long_service,
                          :probation_service)
        end

        context 'when an admin user updates a service of a foreign person' do
          let(:civil_servant) { create :civil_servant, :admin }
          let(:params) { { confirmation_date: new_confirmation_date, beginning: '2018-01-01', ending: '2018-01-26' } }
          let!(:service) { create :service, :unconfirmed, civil_servant: create(:civil_servant) }

          it 'updates confirmation date and adds an expense sheet' do
            expect { put_request }.to(change { service.reload.confirmation_date }.to(new_confirmation_date)
                                        .and(change(ExpenseSheet, :count).by(1)))
          end

          it_behaves_like 'renders a successful http status code' do
            let(:request) { put_request }
          end

          it 'returns the updated service' do
            put_request
            expect(parse_response_json(response)).to include(expected_attributes)
          end
        end

        context 'when an admin user updates the ending of a service' do
          let(:civil_servant) { create :civil_servant, :admin }
          let!(:service) { create :service, civil_servant: create(:civil_servant) }
          let(:params) { { ending: new_ending } }
          let(:new_ending) { (service.ending + 2.months).at_end_of_week - 2.days }
          let(:expense_sheet_generator) { instance_double(ExpenseSheetGenerator, create_missing_expense_sheets: nil) }

          before { allow(ExpenseSheetGenerator).to receive(:new).with(service).and_return(expense_sheet_generator) }

          it 'calls create_missing_expense_sheets' do
            put_request
            expect(expense_sheet_generator).to have_received(:create_missing_expense_sheets)
          end
        end
      end
    end

    describe '#destroy' do
      let(:delete_request) { delete v1_service_path service }
      let(:service) { create :service, civil_servant: user }

      before { service }

      context 'when an admin user tries to delete a foreign service' do
        let(:civil_servant) { create :civil_servant, :admin }
        let(:service) { create :service, civil_servant: create(:civil_servant) }

        it 'deletes the Service' do
          expect { delete_request }.to change(Service, :count).by(-1)
        end

        it_behaves_like 'renders a successful http status code' do
          let(:request) { delete_request }
        end
      end
    end

    describe '#confirm' do
      let(:confirm_request) { put service_confirm_v1_service_path service }
      let!(:service) { create :service, :unconfirmed, civil_servant: user }

      context 'when the user confirm his own service' do
        it 'does update the confirmation_date the Service' do
          expect { confirm_request }.to(change { service.reload.confirmation_date })
        end

        it_behaves_like 'renders a successful http status code' do
          let(:request) { confirm_request }
        end
      end

      context 'when a admin user tries to confirm a foreign service' do
        let(:service) { create :service, :unconfirmed, civil_servant: create(:civil_servant) }

        it 'does update the confirmation_date the Service' do
          expect { confirm_request }.to(change { service.reload.confirmation_date })
        end

        it_behaves_like 'renders a successful http status code' do
          let(:request) { confirm_request }
        end
      end
    end
  end

  context 'when no user is signed in' do
    describe '#index' do
      it_behaves_like 'login protected resource' do
        let(:request) { get v1_services_path }
      end
    end

    describe '#show' do
      let!(:service) { create :service }

      it_behaves_like 'login protected resource' do
        let(:request) { get v1_service_path service }
      end
    end

    describe '#create' do
      subject { -> { request } }

      let(:service_specification) { create :service_specification }
      let(:request) { post v1_services_path service: params }
      let(:civil_servant) { create :civil_servant }
      let(:params) do
        attributes_for(:service, service_type: 'normal')
          .merge(
            service_specification_id: service_specification.id,
            user_id: user.id
          )
      end

      it_behaves_like 'login protected resource'

      it 'does not create a new Services' do
        expect { request }.not_to change(Service, :count)
      end
    end

    describe '#update' do
      let!(:service) { create :service }

      it_behaves_like 'login protected resource' do
        let(:request) { put v1_service_path service, params: { confirmation_date: Time.zone.today.to_s } }
      end
    end

    describe '#destroy' do
      let!(:service) { create :service }
      let(:request) { delete v1_service_path service }

      it 'does not destroy the service' do
        expect { request }.not_to change(Service, :count)
      end

      it_behaves_like 'login protected resource'
    end

    describe '#confirm' do
      let!(:service) { create :service, :unconfirmed }
      let(:request) { put service_confirm_v1_service_path service }

      it 'does not update the service' do
        expect { request }.not_to(change { service.reload.confirmation_date })
      end

      it_behaves_like 'login protected resource'
    end
  end
end
