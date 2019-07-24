# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::UsersController, type: :request do
  let(:user) { create :user }

  describe '#show' do
    let(:requested_user) { user }
    let(:request) { get v1_user_path(requested_user) }
    let(:expected_successful_response_json) do
      extract_to_json(requested_user)
        .except(
          :created_at, :encrypted_password,
          :reset_password_sent_at, :reset_password_token,
          :updated_at
        ).merge(
          beginning: nil,
          ending: nil,
          services: [],
          active: false
        )
    end

    context 'when no user is logged in' do
      it_behaves_like 'login protected resource'
    end

    context 'when a civil servant is logged in' do
      before { sign_in user }

      context 'when he requests himself' do
        it_behaves_like 'renders a successful http status code'

        it 'renders user' do
          request
          expect(parse_response_json(response)).to include expected_successful_response_json
        end
      end

      context 'when he requests a different user than himself' do
        let(:requested_user) { create :user }

        it_behaves_like 'admin protected resource'
      end
    end

    context 'when an admin is logged in' do
      let(:user) { create :user, :admin }

      before { sign_in user }

      context 'when he requests a different user' do
        let(:requested_user) { create :user }

        it_behaves_like 'renders a successful http status code'

        it 'renders user' do
          request
          expect(parse_response_json(response)).to include expected_successful_response_json
        end
      end

      context 'when he requests a different user' do
        let(:request) { get v1_user_path(-1) }

        it_behaves_like 'renders a not found error response'
      end
    end
  end

  describe '#index' do
    let!(:user) { create :user }
    let!(:admin_user) { create :user, :admin }
    let(:request) { get v1_users_path }
    let(:expected_successful_response_json) do
      [user, admin_user].map do |current_user|
        extract_to_json(current_user)
          .merge(
            services: be_an_instance_of(Array),
            beginning: convert_to_json_value(current_user.services.chronologically.last.beginning),
            ending: convert_to_json_value(current_user.services.chronologically.last.ending.to_s),
            active: false
          ).except(
            :created_at, :encrypted_password,
            :reset_password_sent_at, :reset_password_token,
            :updated_at
          )
      end
    end

    before do
      create :service, user: user
      create :service, user: admin_user
    end

    context 'when no user is logged in' do
      it_behaves_like 'login protected resource'
    end

    context 'when a civil servant is logged in' do
      before { sign_in user }

      it_behaves_like 'admin protected resource'
    end

    context 'when an admin is logged in' do
      subject { parse_response_json(response) }

      before do
        sign_in admin_user
        request
      end

      it_behaves_like 'renders a successful http status code'

      it { is_expected.to include(*expected_successful_response_json) }
    end
  end

  describe '#update' do
    let(:request) { put v1_user_path(updated_user), params: { user: params } }
    let(:params) { { first_name: 'Updated first name' } }

    context 'when a civil servant is logged in' do
      let(:civil_servant) { create(:user) }

      before { sign_in civil_servant }

      context 'when he tries to update himself' do
        subject { -> { request } }

        let(:updated_user) { civil_servant }

        context 'when the updated data is correct' do
          it_behaves_like 'renders a successful http status code'

          it { is_expected.to change { updated_user.reload.first_name }.to params[:first_name] }
        end

        context 'when he tries to update an admin protected field' do
          let(:params) { { internal_note: 'Restricted', role: 'admin' } }

          it { is_expected.not_to(change { updated_user.reload.internal_note }) }
          it { is_expected.not_to(change { updated_user.reload.role }) }
        end

        context 'when the updated data is incorrect' do
          let(:params) { { first_name: nil } }

          it_behaves_like 'renders a validation error response'

          it { is_expected.not_to(change { updated_user.reload.first_name }) }

          it 'returns the error' do
            request
            expect(parse_response_json(response)).to include(
              errors: {
                first_name: be_an_instance_of(Array)
              }
            )
          end
        end
      end

      context 'when he tries to update a user other than himself' do
        subject { -> { request } }

        let(:updated_user) { create :user }

        it_behaves_like 'admin protected resource'

        it { is_expected.not_to(change { updated_user.reload.first_name }) }
      end
    end

    context 'when an admin is logged in' do
      subject { -> { request } }

      let(:updated_user) { create :user }

      before { sign_in create(:user, :admin) }

      it_behaves_like 'renders a successful http status code'

      it { is_expected.to change { updated_user.reload.first_name }.to params[:first_name] }

      context 'when he tries to update admin protected fields' do
        let(:params) { { internal_note: 'Restricted', role: 'admin' } }

        it 'changes #role and #internal_note' do
          expect { request }.to change { updated_user.reload.internal_note }.to(params[:internal_note]).and(
            change { updated_user.reload.admin? }.from(false).to(true)
          )
        end
      end
    end

    context 'when no user is logged in' do
      subject { -> { request } }

      let(:updated_user) { create :user }

      it_behaves_like 'login protected resource'

      it { is_expected.not_to(change { updated_user.reload.first_name }) }
    end
  end

  describe '#destroy' do
    let(:request) { delete v1_user_path(requested_user) }
    let!(:requested_user) { create :user }

    context 'when no user is signed in' do
      it_behaves_like 'login protected resource'
    end

    context 'when a civil servant is logged in' do
      before { sign_in create(:user) }

      it_behaves_like 'admin protected resource'

      it 'does not delete the user' do
        expect { request }.not_to change(User, :count)
      end
    end

    context 'when an admin is logged in' do
      let(:admin) { create(:user, :admin) }

      before { sign_in admin }

      it 'deletes a user' do
        expect { request }.to change(User, :count).by(-1)
      end

      context 'when he tries to delete himself' do
        let(:requested_user) { admin }

        it_behaves_like 'renders a validation error response'

        it 'does not delete the user' do
          expect { request }.not_to change(User, :count)
        end
      end

      context 'when the user has associated services' do
        before { create :service, user: requested_user }

        it_behaves_like 'renders a validation error response'

        it 'does not delete the user or it\'s service' do
          expect { request }.to not_change(User, :count).and not_change(Service, :count)
        end
      end
    end
  end
end
