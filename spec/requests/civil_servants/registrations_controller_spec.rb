# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CivilServants::RegistrationsController, :without_bullet, type: :request do
  describe '#edit' do
    let(:perform_request) { get civil_servants_register_path(params) }
    let(:params) { nil }

    context 'when a civil servant is signed in' do
      let(:civil_servant) { create(:civil_servant, :with_user, *traits) }
      let(:traits) { [] }

      before do
        sign_in civil_servant.user
        perform_request
      end

      it 'renders first page successfully' do
        expect(response).to be_successful
        expect(response).to render_template 'civil_servants/registrations/steps/_personal'
      end

      context 'when accessing a future step, which is not yet completed' do
        let(:params) { { displayed_step: 'address' } }

        it 'falls back to last filled out page' do
          expect(response).to render_template 'civil_servants/registrations/steps/_personal'
        end
      end

      context 'when address step completed' do
        let(:traits) { [:address_step_completed] }

        it 'renders address step' do
          expect(response).to render_template 'civil_servants/registrations/steps/_address'
        end

        context 'when personal step is requested' do
          let(:params) { { displayed_step: 'personal' } }

          it 'renders personal step' do
            expect(response).to render_template 'civil_servants/registrations/steps/_personal'
          end
        end
      end

      context 'when requesting a step that does not exist' do
        let(:params) { { displayed_step: 'blubbers' } }
        let(:traits) { [:bank_and_insurance_step_completed] }

        it 'falls back to last step completed' do
          expect(response).to render_template 'civil_servants/registrations/steps/_bank_and_insurance'
        end
      end

      context 'when civil servant already completed registration' do
        let(:traits) { [:service_specific_step_completed] }

        it_behaves_like 'unauthorized request' do
          before { perform_request }
        end
      end
    end

    context 'when no civil servant is signed in' do
      it_behaves_like 'unauthenticated request' do
        before { perform_request }
      end
    end
  end

  describe '#update' do
    let(:perform_request) { patch civil_servants_register_path(params) }
    let(:params) { { civil_servant: civil_servant_params, displayed_step: displayed_step } }
    let(:displayed_step) { nil }
    let(:civil_servant_params) { {} }

    context 'when a civil servant is signed in' do
      let(:civil_servant) { create(:civil_servant, :with_user, *traits) }
      let(:traits) { [] }

      before { sign_in civil_servant.user }

      context 'when no step was completed previously' do
        context 'when filling out form correctly' do
          let(:civil_servant_params) { attributes_for(:civil_servant, :personal_step_completed) }

          it 'accepts personal parameters' do
            expect { perform_request }.to(
              change { civil_servant.reload.registration_step }
                .from(nil)
                .to(RegistrationStep.new(identifier: :personal))
                .and(change { civil_servant.reload.slice(civil_servant_params.keys) })
            )
            expect(response).to redirect_to civil_servants_register_path(displayed_step: 'address')
          end
        end

        context 'when form has errors' do
          let(:civil_servant_params) { { first_name: 'Peter', last_name: 'Parker', hometown: '' } }

          it 'does not update civil servant and renders error' do
            expect { perform_request }.not_to change(civil_servant, :reload)
            expect(response).to render_template 'civil_servants/registrations/steps/_personal'
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response.body).to include I18n.t('civil_servants.registrations.update.erroneous_update')
          end
        end

        context 'when trying to change a step different than the first one' do
          let(:displayed_step) { 'address' }
          let(:civil_servant_params) { { address_attributes: { primary_line: 'First line' } } }

          it 'does not accept the update and redirects to first page' do
            expect { perform_request }.not_to change(civil_servant, :reload)
            expect(response).to render_template 'civil_servants/registrations/steps/_personal'
          end
        end
      end

      context 'when personal step already completed' do
        let(:traits) { [:personal_step_completed] }
        let(:displayed_step) { 'address' }
        let(:civil_servant_params) do
          {
            address_attributes: attributes_for(:address)
          }
        end

        it 'can compile address fields' do
          expect { perform_request }.to(change { civil_servant.reload.address })
          expect(response).to redirect_to civil_servants_register_path(displayed_step: 'bank_and_insurance')
        end
      end

      context 'when submitting last step' do
        let(:traits) { [:bank_and_insurance_step_completed] }
        let(:displayed_step) { 'service_specific' }
        let(:civil_servant_params) { { regional_center: 'rüti' } }

        it 'completes registration and redirects to portal' do
          expect { perform_request }.to(
            change { civil_servant.reload.regional_center&.identifier }.to('rüti')
              .and(change { civil_servant.reload.registered? }.from(false).to(true))
          )
          expect(flash[:success]).to eq I18n.t('successful_registration')
          expect(response).to redirect_to civil_servants_path
        end
      end
    end

    context 'when no civil servant is signed in' do
      it_behaves_like 'unauthenticated request' do
        before { perform_request }
      end
    end
  end
end
