# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::ServicesController, type: :request do
  context 'when user is signed in' do
    let(:user) { create :user }

    before { sign_in user }

    describe '#index' do
      subject(:json_response) { parse_response_json(response) }

      let!(:services) { create_pair :service, beginning: '2018-11-05', ending: '2018-11-30', user: user }
      let(:request) { get v1_services_path }
      let(:first_service_json) do
        extract_to_json(services.first, :beginning, :ending, :confirmation_date, :id)
          .merge(service_specification: extract_to_json(services.first.service_specification,
                                                        :name, :short_name, :identification_number))
          .merge(user: extract_to_json(services.first.user, :id, :first_name, :last_name, :zdp))
      end

      let(:second_service_json) do
        extract_to_json(services.second, :beginning, :ending, :confirmation_date, :id)
          .merge(service_specification: extract_to_json(services.second.service_specification,
                                                        :name, :short_name, :identification_number))
          .merge(user: extract_to_json(services.second.user, :id, :first_name, :last_name, :zdp))
      end

      context 'when the user is admin' do
        let(:user) { create :user, :admin }

        before do
          create :service, beginning: '2019-06-17', ending: '2019-06-28', user: user
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

      context 'when user is not admin' do
        it_behaves_like 'admin protected resource'
      end
    end

    describe '#show' do
      let(:request) { get v1_service_path service }

      before { request }

      context 'when the user has permission to view its own resource' do
        let(:service) { create :service, user: user }
        let(:expected_response) do
          extract_to_json(service, :id, :user_id, :service_specification_identification_number,
                          :beginning, :ending, :confirmation_date, :eligible_personal_vacation_days,
                          :service_type, :first_swo_service, :long_service,
                          :probation_service, :feedback_mail_sent)
        end

        it_behaves_like 'renders a successful http status code'

        it 'renders the correct response' do
          expect(parse_response_json(response)).to include(expected_response)
        end

        context 'when the user is admin' do
          let(:user) { create(:user, :admin) }
          let(:service) { create :service, user: create(:user) }

          it 'is able to view services from different people' do
            expect(parse_response_json(response)).to include(expected_response)
          end
        end

        context 'when the requested resource does not exist' do
          it_behaves_like 'renders a not found error response' do
            let(:request) { get v1_service_path(-2) }
          end
        end
      end

      context 'when a non-admin user requests a service which is not his own' do
        let(:service) { create :service, user: create(:user) }

        it_behaves_like 'admin protected resource'
      end
    end

    describe '#create' do
      subject { -> { post_request } }

      let(:service_specification) { create :service_specification }
      let(:post_request) { post v1_services_path(service: params) }

      let(:valid_params) do
        attributes_for(:service, :unconfirmed, service_type: 'normal')
          .merge(
            service_specification_identification_number: service_specification.identification_number,
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
            eligible_personal_vacation_days
            service_type
            first_swo_service
            long_service
            probation_service
            feedback_mail_sent
          ]
        end

        it_behaves_like 'renders a successful http status code' do
          let(:request) { post_request }
        end

        it { is_expected.to change(Service, :count).by(1) }

        it 'returns the created service' do
          post_request
          expect(parse_response_json(response)).to include(
            params.slice(*expected_returned_attributes).merge(
              service_specification_identification_number: Service.last.identification_number
            )
          )
        end

        context 'when a non-admin user tries to create a service for another user' do
          let(:other_user) { create :user }
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

        context 'when a admin user tries to create a service for another user' do
          let(:user) { create :user, :admin }
          let(:other_user) { create :user }
          let(:params) { valid_params.merge(user_id: other_user.id) }

          it 'creates the service in the name of the other user' do
            expect { post_request }.to(change { other_user.reload.services.count }.by(1))
          end

          it 'does not create the service in the name of the logged in user' do
            expect { post_request }.not_to(change { user.reload.services.count })
          end
        end
      end

      context 'when params are invalid' do
        let(:params) do
          valid_params.merge(
            beginning: Time.zone.today.end_of_week.to_s, ending: 'I am invalid'
          )
        end

        it { is_expected.to change(Service, :count).by(0) }

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
      let!(:service) { create :service, :unconfirmed, user: user }
      let(:put_request) { put v1_service_path(service, params: { service: params }) }

      context 'with valid params' do
        subject { -> { put_request } }

        let(:new_service_date) { service.beginning - 7.days }
        let(:new_confirmation_date) { service.beginning - 8.days }
        let(:params) { { beginning: new_service_date, confirmation_date: new_confirmation_date } }
        let(:expected_attributes) do
          extract_to_json(service, :id, :user_id, :service_specification_identification_number, :beginning,
                          :ending, :confirmation_date, :eligible_personal_vacation_days,
                          :service_type, :first_swo_service, :long_service,
                          :probation_service, :feedback_mail_sent)
        end

        context 'when a non-admin user updates it\'s own service' do
          it { is_expected.to(change { service.reload.beginning }.to(new_service_date)) }

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

        context 'when a non-admin user tries to update other\'s service' do
          let!(:service) { create :service, :unconfirmed, user: create(:user) }

          it_behaves_like 'admin protected resource' do
            let(:request) { put_request }
          end

          it { is_expected.not_to(change { service.reload.confirmation_date }) }
        end

        context 'when an admin user updates a service of a foreign person' do
          let(:user) { create :user, :admin }
          let!(:service) { create :service, :unconfirmed, user: create(:user) }

          it { is_expected.to(change { service.reload.confirmation_date }.to(new_confirmation_date)) }

          it_behaves_like 'renders a successful http status code' do
            let(:request) { put_request }
          end

          it 'returns the updated service' do
            put_request
            expect(parse_response_json(response)).to include(expected_attributes)
          end
        end
      end

      context 'with invalid params' do
        let(:user) { create :user, :admin }
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
      subject { -> { delete_request } }

      let(:delete_request) { delete v1_service_path service }
      let(:service) { create :service, user: user }

      before { service }

      context 'when the user deletes his own service' do
        it { is_expected.to change(Service, :count).by(-1) }

        it_behaves_like 'renders a successful http status code' do
          let(:request) { delete_request }
        end
      end

      context 'when a non-admin user tries to delete a foreign service' do
        let(:service) { create :service, user: create(:user) }

        it { is_expected.not_to change(Service, :count) }

        it_behaves_like 'admin protected resource' do
          let(:request) { delete_request }
        end
      end

      context 'when an admin user tries to delete a foreign service' do
        let(:user) { create :user, :admin }
        let(:service) { create :service, user: create(:user) }

        it { is_expected.to change(Service, :count).by(-1) }

        it_behaves_like 'renders a successful http status code' do
          let(:request) { delete_request }
        end
      end

      context 'when the requested resource does not exist' do
        let(:request) { delete v1_service_path(-1) }

        it_behaves_like 'renders a not found error response'
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
      let(:user) { create :user }
      let(:params) do
        attributes_for(:service, service_type: 'normal')
          .merge(
            service_specification_id: service_specification.id,
            user_id: user.id
          )
      end

      it_behaves_like 'login protected resource'

      it { is_expected.not_to change(Service, :count) }
    end

    describe '#update' do
      let!(:service) { create :service }

      it_behaves_like 'login protected resource' do
        let(:request) { put v1_service_path service, params: { confirmation_date: Time.zone.today.to_s } }
      end
    end

    describe '#destroy' do
      subject { -> { request } }

      let!(:service) { create :service }
      let(:request) { delete v1_service_path service }

      it { is_expected.not_to change(Service, :count) }

      it_behaves_like 'login protected resource'
    end
  end
end
