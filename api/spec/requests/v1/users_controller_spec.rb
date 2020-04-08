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
          :created_at, :encrypted_password, :legacy_password,
          :reset_password_sent_at, :reset_password_token,
          :updated_at
        ).merge(
          services: [],
          bank_iban: requested_user.prettified_bank_iban
        )
    end

    context 'when no user is logged in' do
      it_behaves_like 'login protected resource'
    end

    context 'when a civil servant is logged in' do
      before { sign_in civil_servant.user }

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

      before { sign_in civil_servant.user }

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
        extract_to_json(current_user, :id, :zdp, :role)
          .merge(
            beginning: convert_to_json_value(current_user.services.last.beginning),
            ending: convert_to_json_value(current_user.services.last.ending.to_s),
            active: current_user.active?,
            full_name: current_user.full_name
          )
      end
    end

    let(:now) { Time.zone.today }

    before do
      create :service, user: user, beginning: (now - 4.weeks).at_beginning_of_week, ending: now.at_end_of_week + 5.days
      create(:service,
             user: admin_user,
             beginning: (now + 1.month).at_beginning_of_week,
             ending: (now + 2.months).at_end_of_week - 2.days)
    end

    context 'when no user is logged in' do
      it_behaves_like 'login protected resource'
    end

    context 'when a civil servant is logged in' do
      before { sign_in civil_servant.user }

      it_behaves_like 'admin protected resource'
    end

    context 'when an admin is logged in' do
      subject(:json_response) { parse_response_json(response) }

      before do
        sign_in admin_user
        request
      end

      it_behaves_like 'renders a successful http status code'

      it 'returns expected JSON response' do
        expect(json_response).to include(*expected_successful_response_json)
      end
    end
  end

  describe '#update' do
    let(:request) { put v1_user_path(updated_user), params: { user: params } }
    let(:params) do
      { first_name: 'Updated first name', bank_iban: 'CH56 0483 5012 3456 7800 9' }
    end

    context 'when a civil servant is logged in' do
      let(:user) { create(:user) }

      before { sign_in civil_servant.user }

      context 'when he tries to update himself' do
        let(:updated_user) { user }

        context 'when the updated data is correct' do
          it_behaves_like 'renders a successful http status code'

          it 'updates the user' do
            expect { request }.to change { updated_user.reload.first_name }.to(params[:first_name]).and(
              change { updated_user.reload.bank_iban }.to(User.strip_iban(params[:bank_iban]))
            )
          end
        end

        context 'when he tries to update an admin protected field' do
          let(:params) { { internal_note: 'Restricted', role: 'admin' } }

          it 'does not change the internal notes field' do
            expect { request }.not_to(change { updated_user.reload.internal_note })
          end

          it 'does not update the role' do
            expect { request }.not_to(change { updated_user.reload.role })
          end
        end

        context 'when the updated data is incorrect' do
          let(:params) { { first_name: nil } }

          it_behaves_like 'renders a validation error response'

          it 'does not update the user' do
            expect { request }.not_to(change { updated_user.reload.first_name })
          end

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

        it 'does not update the user' do
          expect { request }.not_to(change { updated_user.reload.first_name })
        end
      end
    end

    context 'when an admin is logged in' do
      let(:updated_user) { create :user }

      before { sign_in create(:user, :admin) }

      it_behaves_like 'renders a successful http status code'

      it 'does update the user' do
        expect { request }.to change { updated_user.reload.first_name }.to params[:first_name]
      end

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
      let(:updated_user) { create :user }

      it_behaves_like 'login protected resource'

      it 'does not update the user' do
        expect { request }.not_to(change { updated_user.reload.first_name })
      end
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

        it 'renders deletion error message' do
          request
          expect(parse_response_json(response)[:human_readable_descriptions]).to eq(
            [I18n.t('activerecord.errors.models.user.attributes.base.cant_delete_himself')]
          )
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
