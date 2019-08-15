# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::ExpenseSheetsController, type: :request do
  context 'when the user is signed in' do
    let(:user) { create :user }

    before { sign_in user }

    describe '#index' do
      let(:request) { get v1_expense_sheets_path }

      context 'when user is admin' do
        let!(:user) { create :user, :admin }
        let(:expense_sheets) { create_list :expense_sheet, 3, user: user }
        let(:service_beginning) { expense_sheets.first.beginning.at_beginning_of_week }
        let(:service_ending) { expense_sheets.first.ending.at_end_of_week - 2.days }
        let(:total) { 74_500 }
        let!(:json_expense_sheets) do
          expense_sheets.map do |expense_sheet|
            extract_to_json(expense_sheet).except(:created_at, :updated_at)
                                          .merge(duration: expense_sheet.duration, total: total)
          end
        end

        before do
          create :service,
                 beginning: service_beginning,
                 ending: service_ending,
                 user: user
        end

        it 'returns all expense sheets' do
          request
          expect(parse_response_json(response)).to include(*json_expense_sheets)
        end

        it_behaves_like 'renders a successful http status code' do
          before { expense_sheets }
        end

        context 'with no valid filter' do
          let(:request) { get v1_expense_sheets_path(filter: 'invalid filter') }

          it 'returns all expense sheets' do
            request
            expect(parse_response_json(response)).to include(*json_expense_sheets)
          end
        end

        context 'with current filter' do
          let(:request) { get v1_expense_sheets_path(filter: 'current') }
          let(:included_beginning) { Time.zone.today - 2.months }
          let(:included_ending) { Time.zone.today.at_end_of_month }
          let(:excluded_beginning) { Time.zone.today + 2.months }
          let(:excluded_ending) { Time.zone.today + 3.months }
          let(:service_beginning) { included_beginning.at_beginning_of_week }
          let(:service_ending) { (excluded_ending + 1.week).at_end_of_week - 2.days }
          let(:total) { 75_200 }
          let(:expense_sheets) do
            create_list(:expense_sheet, 3, beginning: included_beginning, ending: included_ending, user: user)
          end

          before do
            create :expense_sheet, :payment_in_progress
            create :expense_sheet, :paid
            create :expense_sheet, :ready_for_payment, beginning: excluded_beginning, ending: excluded_ending
            create :expense_sheet, beginning: excluded_beginning, ending: excluded_ending
          end

          it 'returns only the filtered expense_sheets' do
            request
            expect(parse_response_json(response)).to eq(json_expense_sheets)
          end
        end

        context 'with pending filter' do
          let(:request) { get v1_expense_sheets_path(filter: 'pending') }
          let(:expense_sheets) do
            create_list(:expense_sheet, 3, user: user)
              .append(*create_list(:expense_sheet, 2, :ready_for_payment, user: user))
          end

          before do
            create :expense_sheet, :payment_in_progress
            create :expense_sheet, :paid
          end

          it 'returns only the filtered expense_sheets' do
            request
            expect(parse_response_json(response)).to eq(json_expense_sheets)
          end
        end

        context 'with ready_for_payment filter' do
          let(:request) { get v1_expense_sheets_path(filter: 'ready_for_payment') }
          let(:expense_sheets) { create_list(:expense_sheet, 2, :ready_for_payment, user: user) }

          before do
            create :expense_sheet, :payment_in_progress
            create :expense_sheet, :paid
            create :expense_sheet
          end

          it 'returns only the filtered expense_sheets' do
            request
            expect(parse_response_json(response)).to eq(json_expense_sheets)
          end
        end
      end

      context 'when user is not admin' do
        it_behaves_like 'admin protected resource'
      end
    end

    describe '#hints' do
      let(:service) { create :service }
      let!(:expense_sheet) do
        create :expense_sheet, user: service.user, beginning: service.beginning, ending: service.ending
      end
      let(:request) { get hints_v1_expense_sheet_path(expense_sheet) }

      context 'when user is admin' do
        subject { -> { request } }

        let(:user) { create :user, :admin }
        let(:suggestions_calculator) do
          instance_double(ExpenseSheetCalculators::SuggestionsCalculator, suggestions: expected_suggestions)
        end
        let(:remaining_days_calculator) do
          instance_double(ExpenseSheetCalculators::RemainingDaysCalculator, remaining_days: expected_remaining_days)
        end
        let(:expected_suggestions) { { work_days: 20 } }
        let(:expected_remaining_days) { { sick_days: 6 } }

        before do
          allow(ExpenseSheetCalculators::SuggestionsCalculator).to receive(:new)
            .with(expense_sheet).and_return(suggestions_calculator)
          allow(ExpenseSheetCalculators::RemainingDaysCalculator).to receive(:new)
            .with(service).and_return(remaining_days_calculator)
        end

        it_behaves_like 'renders a successful http status code'

        it 'returns the correct hints' do
          request
          expect(parse_response_json(response)).to eq(
            suggestions: expected_suggestions,
            remaining_days: expected_remaining_days
          )
        end
      end

      context 'when user is not admin' do
        it_behaves_like 'admin protected resource'
      end
    end

    describe '#create' do
      context 'when user is admin' do
        subject { -> { post_request } }

        let(:user) { create :user, :admin }
        let(:post_request) { post v1_expense_sheets_path(expense_sheet: params) }
        let(:params) do
          attributes_for(:expense_sheet).merge(
            user_id: user.id, beginning: '2019-04-29', ending: '2019-05-05', state: 'open'
          )
        end

        before { create :service, user: user, beginning: '2019-04-29', ending: '2019-05-10' }

        context 'when params are valid' do
          it_behaves_like 'renders a successful http status code' do
            let(:request) { post_request }
          end

          it { is_expected.to change(ExpenseSheet, :count).by(1) }

          it 'returns the created expense_sheet' do
            post_request
            expect(parse_response_json(response)).to include(
              id: ExpenseSheet.last.id,
              beginning: params[:beginning],
              ending: params[:ending],
              state: params[:state],
              workfree_days: params[:workfree_days],
              user_id: params[:user_id]
            )
          end
        end

        context 'when params are invalid' do
          let(:params) { { driving_expenses: 'aa', ending: 'I am invalid' } }

          it { is_expected.to change(ExpenseSheet, :count).by(0) }

          it_behaves_like 'renders a validation error response' do
            let(:request) { post_request }
          end

          it 'renders all validation errors' do
            post_request
            expect(parse_response_json(response)[:errors]).to include(
              ending: be_an_instance_of(Array),
              beginning: be_an_instance_of(Array),
              driving_expenses: be_an_instance_of(Array)
            )
          end
        end
      end

      context 'when user is not admin' do
        it_behaves_like 'admin protected resource' do
          let(:request) { post v1_expense_sheets_path }
        end
      end
    end

    describe '#update' do
      let!(:service) do
        create :service,
               beginning: expense_sheet.beginning.at_beginning_of_week,
               ending: expense_sheet.ending.at_end_of_week - 2.days,
               user: expense_sheet.user
      end
      let(:expense_sheet) { create :expense_sheet }

      context 'when user is admin' do
        let(:user) { create :user, :admin }
        let(:put_request) { put v1_expense_sheet_path(expense_sheet, params: { expense_sheet: params }) }

        context 'with valid params' do
          subject { -> { put_request } }

          let(:params) { { driving_expenses: 6969 } }
          let(:expected_attributes) do
            extract_to_json(expense_sheet, :beginning, :ending, :driving_expenses, :id).merge(service_id: service.id)
          end

          it { is_expected.to(change { expense_sheet.reload.driving_expenses }.to(6969)) }

          it_behaves_like 'renders a successful http status code' do
            let(:request) { put_request }
          end

          it 'returns the updated expense_sheet' do
            put_request
            expect(parse_response_json(response)).to include(expected_attributes)
          end
        end

        context 'with invalid params' do
          let(:params) { { driving_expenses: 'a' } }

          it_behaves_like 'renders a validation error response' do
            let(:request) { put_request }
          end

          it 'renders all validation errors' do
            put_request
            expect(parse_response_json(response)[:errors]).to include(
              driving_expenses: be_an_instance_of(Array)
            )
          end
        end

        context 'when the requested resource does not exist' do
          it_behaves_like 'renders a not found error response' do
            let(:request) { put v1_expense_sheet_path(-2) }
          end
        end
      end

      context 'when user is not admin' do
        it_behaves_like 'admin protected resource' do
          let(:request) { put v1_expense_sheet_path(expense_sheet) }
        end
      end
    end

    describe '#destroy' do
      let!(:expense_sheet) { create :expense_sheet }

      context 'when user is admin' do
        subject { -> { delete_request } }

        let(:user) { create :user, :admin }
        let(:delete_request) { delete v1_expense_sheet_path(expense_sheet) }

        it { is_expected.to change(ExpenseSheet, :count).by(-1) }

        it_behaves_like 'renders a successful http status code' do
          let(:request) { delete_request }
        end

        context 'when the expense_sheet is already paid' do
          let(:expense_sheet) { create :expense_sheet, :paid }

          it_behaves_like 'renders a validation error response' do
            let(:request) { delete_request }
          end
        end

        context 'when the requested resource does not exist' do
          let(:request) { delete v1_expense_sheet_path(-2) }

          it_behaves_like 'renders a not found error response'

          it 'does not delete anything' do
            expect { request }.not_to change(ExpenseSheet, :count)
          end
        end
      end

      context 'when user is not admin' do
        it_behaves_like 'admin protected resource' do
          let(:request) { delete v1_expense_sheet_path(expense_sheet) }
        end
      end
    end

    describe '#show' do
      subject { -> { request } }

      let!(:service) do
        create :service,
               beginning: expense_sheet.beginning.at_beginning_of_week,
               ending: expense_sheet.ending.at_end_of_week - 2.days,
               user: expense_sheet.user
      end
      let(:expense_sheet) { create :expense_sheet }
      let(:request) { get v1_expense_sheet_path(expense_sheet) }

      context 'when user is admin' do
        let(:user) { create :user, :admin }
        let(:expected_response) do
          extract_to_json(expense_sheet)
            .except(:created_at, :updated_at)
            .merge(service_id: service.id, duration: 31, total: 74_500)
        end

        it_behaves_like 'renders a successful http status code'

        it 'returns the expected response' do
          request
          expect(parse_response_json(response)).to eq expected_response
        end

        context 'when the requested resource does not exist' do
          let(:request) { get v1_expense_sheet_path(-2) }

          it_behaves_like 'renders a not found error response'
        end
      end

      context 'when user is not admin' do
        it_behaves_like 'admin protected resource'
      end
    end
  end

  context 'when no user is signed in' do
    describe '#index' do
      it_behaves_like 'login protected resource' do
        let(:request) { get v1_expense_sheets_path }
      end
    end

    describe '#create' do
      let(:params) { attributes_for(:expense_sheet) }
      let(:request) { post v1_expense_sheets_path(expense_sheet: params) }

      it_behaves_like 'login protected resource'

      it 'does not create a new expense_sheet' do
        expect { request }.not_to change(ExpenseSheet, :count)
      end
    end

    describe '#update' do
      let!(:expense_sheet) { create :expense_sheet }
      let(:request) { put v1_expense_sheet_path(expense_sheet, params: { expense_sheet: params }) }
      let(:params) { { driving_expenses: 1000 } }

      it_behaves_like 'login protected resource'

      it 'does not update the expense_sheet' do
        expect { request }.not_to(change { expense_sheet.reload.driving_expenses })
      end
    end

    describe '#destroy' do
      let!(:expense_sheet) { create :expense_sheet }
      let(:request) { delete v1_expense_sheet_path(expense_sheet) }

      it_behaves_like 'login protected resource'

      it 'does not delete the expense_sheet' do
        expect { request }.not_to change(ExpenseSheet, :count)
      end
    end
  end

  describe '#show' do
    let(:request) { get v1_expense_sheet_path(format: :pdf, id: expense_sheet.id), params: { token: token } }
    let!(:user) { create :user }
    let(:expense_sheet) { create :expense_sheet, user: user, beginning: beginning, ending: ending }
    let(:service) do
      create :service,
             beginning: beginning,
             ending: ending,
             user: expense_sheet.user
    end

    let(:beginning) { (Time.zone.today - 3.months).beginning_of_week }
    let(:ending) { (Time.zone.today - 1.week).end_of_week - 2.days }

    context 'when a token is provided' do
      let(:token) { generate_jwt_token_for_user(user) }

      context 'when user is admin' do
        let(:user) { create :user, :admin }

        before { service }

        it_behaves_like 'renders a successful http status code'

        it 'returns a content type pdf' do
          request
          expect(response.headers['Content-Type']).to include 'pdf'
        end
      end

      context 'when user is civil servant' do
        it_behaves_like 'admin protected resource'
      end
    end

    context 'when no token is provided' do
      subject { -> { request } }

      let(:token) { nil }

      it { is_expected.to raise_exception ActionController::ParameterMissing }
    end

    context 'when an invalid token is provided' do
      let(:token) { 'invalid' }

      it_behaves_like 'admin protected resource'
    end
  end
end
