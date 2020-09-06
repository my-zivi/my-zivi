# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organizations::PhoneListController, type: :request do
  let(:organization) { create :organization }

  context 'when signed in as an organization administrator' do
    let(:organization_administrator) { create :organization_member, organization: organization }
    let(:civil_servant) { create :civil_servant, :full, :with_service }

    before { sign_in organization_administrator.user }

    describe '#index' do
      context 'when format is html' do
        before { get organizations_phone_list_path(params: params) }

        let(:params) { {} }

        context 'when there is no filter' do
          it 'returns http success' do
            expect(response).to have_http_status(:success)
            expect(response.body).to include I18n.t('organizations.phone_list.index.title.without_filter')
          end
        end

        context 'when there is date range filter' do
          let(:params) do
            {
              filters: {
                range: '01.09.2020bis30.09.2020'
              }
            }
          end

          it 'returns http success' do
            expect(response).to have_http_status(:success)
            expect(response.body).to include I18n.t('organizations.phone_list.index.title.with_filter')
          end
        end
      end

      context 'when format is pdf' do
        before { get organizations_phone_list_path(format: :pdf) }

        context 'when there is no filter' do
          it 'returns correct response' do
            expect(response).to have_http_status(:success)
            expect(response.content_type).to eq 'application/pdf'
            expect(response.content_length).to be_positive
          end
        end

        context 'when there is date range filter' do
          let(:filter) do
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
