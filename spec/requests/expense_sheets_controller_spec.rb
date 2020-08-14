# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpenseSheetsController, type: :request do
  describe '#show' do
    describe 'pdf' do
      let(:perform_request) { get expense_sheet_path(expense_sheet, format: :pdf) }
      let(:expense_sheet) { create :expense_sheet, :with_service }

      context 'when a civil servant is signed in' do
        let(:civil_servant) { expense_sheet.service.civil_servant }

        before { sign_in civil_servant.user }

        it 'returns http success' do
          perform_request
          expect(response).to have_http_status(:success)
          expect(response.content_type).to eq 'application/pdf'
          expect(response.content_length).to be_positive
        end
      end

      context 'when nobody is signed in' do
        before { perform_request }

        it_behaves_like 'unauthenticated request'
      end
    end
  end
end
