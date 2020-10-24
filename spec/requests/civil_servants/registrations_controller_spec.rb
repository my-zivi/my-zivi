# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CivilServants::RegistrationsController, type: :request do
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

        it 'renders address step', :without_bullet do
          expect(response).to render_template 'civil_servants/registrations/steps/_address'
        end

        context 'when personal step is requested' do
          let(:params) { { displayed_step: 'personal' } }

          it 'renders personal step' do
            expect(response).to render_template 'civil_servants/registrations/steps/_personal'
          end
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
