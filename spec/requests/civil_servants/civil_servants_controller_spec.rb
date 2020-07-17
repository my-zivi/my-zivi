# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CivilServants::CivilServantsController, type: :request do
  describe '#edit' do
    let(:perform_request) { get edit_civil_servants_civil_servant_path }

    context 'when a civil servant is signed in' do
      let(:civil_servant) { create :civil_servant, :full }

      before { sign_in civil_servant.user }

      it 'returns http success' do
        perform_request
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe '#update' do
    let(:perform_request) do
      patch civil_servants_civil_servant_path(civil_servant, params: request_params, format: :js)
    end
    let(:civil_servant) { create :civil_servant, :full }
    let(:request_params) do
      {
        civil_servant: update_params,
        form_partial: 'personal_information_form'
      }
    end
    let(:update_params) do
      {
        first_name: 'Lara',
        last_name: 'Croft',
        phone: '0448674567'
      }
    end

    context 'when a civil servant is signed in' do
      before { sign_in civil_servant.user }

      it 'updates the organization member' do
        expect { perform_request }.to(change { civil_servant.reload.slice(update_params.keys) }.to(update_params))
        expect(flash[:success]).to eq I18n.t('civil_servants.civil_servants.update.successfully_updated')
        expect(response).to redirect_to edit_civil_servants_civil_servant_path
      end

      context 'when updating the email address' do
        let(:update_params) do
          { user_attributes: { email: 'my.new.email@example.com', id: civil_servant.user.id } }
        end

        it 'sends a confirmation email' do
          expect { perform_request }.to(change { ActionMailer::Base.deliveries.length })
        end
      end

      context 'when updating with invalid data' do
        let(:update_params) { { first_name: '' } }

        it 'does not touch the civil_servant and renders an error message' do
          expect { perform_request }.not_to(change(civil_servant, :reload))
          expect(response).to render_template(:update)
        end
      end

      context 'when requesting a wrong form_partial' do
        let(:update_params) { { first_name: '' } }
        let(:request_params) do
          {
            civil_servant: update_params,
            form_partial: 'not_valid_form'
          }
        end

        it 'does not touch the civil_servant and redirects' do
          perform_request
          expect(response).to have_http_status(:redirect)
          expect(flash[:error]).to eq I18n.t('civil_servants.civil_servants.erroneous_update')
          expect { perform_request }.not_to(change(civil_servant, :reload))
        end
      end
    end
  end
end
