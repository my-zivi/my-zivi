# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::PaymentsController, type: :request do
  let!(:user) { create :user }

  let(:beginning) { Date.parse('2018-01-01') }
  let(:ending) { Date.parse('2018-02-23') }

  let!(:payment_timestamp) { Time.zone.now }

  describe '#show' do
    context 'with token authentication' do
      let(:request) do
        get v1_payment_path(format: :xml, payment_timestamp: payment_timestamp.to_i), params: { token: token }
      end
      let(:token) { generate_jwt_token_for_user(user) }

      before do
        create :expense_sheet, :payment_in_progress,
               user: user,
               beginning: beginning,
               ending: ending,
               payment_timestamp: payment_timestamp
        create :service, user: user, beginning: beginning, ending: ending
      end

      context 'when user is an admin' do
        let(:user) { create :user, :admin }

        it_behaves_like 'renders a successful http status code'

        it 'returns a content type xml' do
          request
          expect(response.headers['Content-Type']).to include 'xml'
        end
      end

      context 'when user is a civil servant' do
        it_behaves_like 'admin protected resource'
      end

      context 'when no token is provided' do
        let(:token) { nil }

        it 'raises ParameterMissing exception' do
          expect { request }.to raise_exception ActionController::ParameterMissing
        end
      end

      context 'when an invalid token is provided' do
        let(:token) { 'invalid' }

        it_behaves_like 'admin protected resource'
      end
    end

    context 'with normal authentication' do
      let(:request) { get v1_payment_path(payment_timestamp: payment_timestamp.to_i) }

      context 'when user is an admin' do
        let(:user) { create :user, :admin }

        before { sign_in user }

        context 'when there is a payment' do
          before do
            create :service, user: user, beginning: beginning, ending: ending
          end

          let!(:payment) do
            Payment.new(expense_sheets: expense_sheets, payment_timestamp: payment_timestamp).tap(&:save)
          end
          let(:expense_sheets) do
            [
              create(:expense_sheet, :payment_in_progress,
                     user: user,
                     beginning: beginning,
                     ending: beginning.at_end_of_month),
              create(:expense_sheet, :payment_in_progress,
                     user: user,
                     beginning: ending.at_beginning_of_month,
                     ending: ending)
            ]
          end

          let(:expected_user_attributes) { %i[id zdp bank_iban] }
          let(:expected_user_response) do
            extract_to_json(user, *expected_user_attributes).merge(full_name: user.full_name)
          end
          let(:expected_response) do
            {
              payment_timestamp: payment.payment_timestamp.to_i,
              state: 'payment_in_progress',
              total: payment.total,
              expense_sheets: payment.expense_sheets.map do |expense_sheet|
                extract_to_json(expense_sheet, :id)
                  .merge(total: expense_sheet.total)
                  .merge(user: expected_user_response)
              end
            }
          end

          it_behaves_like 'renders a successful http status code'

          it 'returns a content type json' do
            request
            expect(response.headers['Content-Type']).to include 'json'
          end

          it 'renders the correct response' do
            request
            expect(parse_response_json(response)).to eq(expected_response)
          end
        end

        context 'when there is no payment' do
          it_behaves_like 'renders a not found error response'
        end
      end

      context 'when user is a civil servant' do
        before { sign_in user }

        it_behaves_like 'admin protected resource'
      end

      context 'when no user is logged in' do
        it_behaves_like 'login protected resource'
      end
    end
  end

  describe '#destroy' do
    let(:request) { delete v1_payment_path(payment_timestamp: payment_timestamp.to_i) }

    context 'when user is an admin' do
      let(:user) { create :user, :admin }

      before { sign_in user }

      context 'when there is a payment' do
        before do
          create :service, user: user, beginning: beginning, ending: ending
        end

        let!(:payment) do
          Payment.new(expense_sheets: expense_sheets, payment_timestamp: payment_timestamp).tap(&:save)
        end
        let(:expense_sheets) do
          [
            create(:expense_sheet, :payment_in_progress,
                   user: user,
                   beginning: beginning,
                   ending: beginning.at_end_of_month),
            create(:expense_sheet, :payment_in_progress,
                   user: user,
                   beginning: ending.at_beginning_of_month,
                   ending: ending)
          ]
        end

        let(:expected_user_attributes) { %i[id zdp bank_iban] }
        let(:expected_user_response) do
          extract_to_json(user, *expected_user_attributes).merge(full_name: user.full_name)
        end
        let(:expected_response) do
          {
            payment_timestamp: 0,
            state: 'ready_for_payment',
            total: payment.total,
            expense_sheets: payment.expense_sheets.map do |expense_sheet|
              extract_to_json(expense_sheet, :id)
                .merge(total: expense_sheet.total)
                .merge(user: expected_user_response)
            end
          }
        end

        it_behaves_like 'renders a successful http status code'

        it 'returns a content type json' do
          request
          expect(response.headers['Content-Type']).to include 'json'
        end

        it 'renders the correct response' do
          request
          expect(parse_response_json(response)).to eq(expected_response)
        end

        it 'changes expense_sheets states' do
          expect { request }.to change { expense_sheets.map(&:reload).map(&:state).uniq }.to ['ready_for_payment']
        end

        it 'changes expense_sheets payment_timestamps' do
          expect { request }.to change { expense_sheets.map(&:reload).map(&:payment_timestamp).uniq }.to [nil]
        end

        context 'when the payment is confirmed' do
          before { payment.confirm }

          it 'renders all validation errors' do
            request
            expect(parse_response_json(response)[:errors]).to include(
              state: be_an_instance_of(Array)
            )
          end

          it 'doesnt update expense_sheets' do
            expect { request }.not_to change(-> { expense_sheets.map(&:reload) }, :call)
          end
        end
      end

      context 'when there is no payment' do
        it_behaves_like 'renders a not found error response'
      end
    end

    context 'when user is a civil servant' do
      before { sign_in user }

      it_behaves_like 'admin protected resource'
    end

    context 'when no user is logged in' do
      it_behaves_like 'login protected resource'
    end
  end

  describe '#confirm' do
    let(:request) { put v1_payment_confirm_path(payment_timestamp: payment_timestamp.to_i) }

    context 'when user is an admin' do
      let(:user) { create :user, :admin }

      before { sign_in user }

      context 'when there is a payment' do
        before do
          create :service, user: user, beginning: beginning, ending: ending
        end

        let!(:payment) do
          Payment.new(expense_sheets: expense_sheets, payment_timestamp: payment_timestamp).tap(&:save)
        end
        let(:expense_sheets) do
          [
            create(:expense_sheet, :payment_in_progress,
                   user: user,
                   beginning: beginning,
                   ending: beginning.at_end_of_month),
            create(:expense_sheet, :payment_in_progress,
                   user: user,
                   beginning: ending.at_beginning_of_month,
                   ending: ending)
          ]
        end

        let(:expected_user_attributes) { %i[id zdp bank_iban] }
        let(:expected_user_response) do
          extract_to_json(user, *expected_user_attributes).merge(full_name: user.full_name)
        end
        let(:expected_response) do
          {
            payment_timestamp: payment.payment_timestamp.to_i,
            state: 'paid',
            total: payment.total,
            expense_sheets: payment.expense_sheets.map do |expense_sheet|
              extract_to_json(expense_sheet, :id)
                .merge(total: expense_sheet.total)
                .merge(user: expected_user_response)
            end
          }
        end

        it_behaves_like 'renders a successful http status code'

        it 'returns a content type json' do
          request
          expect(response.headers['Content-Type']).to include 'json'
        end

        it 'renders the correct response' do
          request
          expect(parse_response_json(response)).to eq(expected_response)
        end

        it 'changes expense_sheets states' do
          expect { request }.to change { expense_sheets.map(&:reload).map(&:state).uniq }.to ['paid']
        end

        it 'doesnt change expense_sheets payment_timestamps' do
          expect { request }.not_to change(-> { expense_sheets.map(&:reload).map(&:payment_timestamp).uniq }, :call)
        end

        context 'when the payment is confirmed' do
          before { payment.confirm }

          it 'doesnt update expense_sheets' do
            expect { request }.not_to(change { expense_sheets.map(&:reload) })
          end
        end
      end

      context 'when there is no payment' do
        it_behaves_like 'renders a not found error response'
      end
    end

    context 'when user is a civil servant' do
      before { sign_in user }

      it_behaves_like 'admin protected resource'
    end

    context 'when no user is logged in' do
      it_behaves_like 'login protected resource'
    end
  end

  describe '#create' do
    let(:request) { post v1_payments_path }
    let(:payment_timestamp) { Payment.floor_time Time.zone.now }

    context 'when user is an admin' do
      let(:user) { create :user, :admin }

      before { sign_in user }

      context 'when there are ready expense_sheets' do
        before do
          create :service, user: user, beginning: beginning, ending: ending
          allow(Time.zone).to receive(:now).and_return(payment_timestamp)
        end

        let!(:expense_sheets) do
          [
            create(:expense_sheet, :ready_for_payment,
                   user: user,
                   beginning: beginning,
                   ending: beginning.at_end_of_month),
            create(:expense_sheet, :ready_for_payment,
                   user: user,
                   beginning: ending.at_beginning_of_month,
                   ending: ending)
          ]
        end

        let(:expected_user_attributes) { %i[id zdp bank_iban] }
        let(:expected_user_response) do
          extract_to_json(user, *expected_user_attributes).merge(full_name: user.full_name)
        end
        let(:expected_response) do
          {
            payment_timestamp: payment_timestamp.to_i,
            state: 'payment_in_progress',
            total: expense_sheets.sum(&:calculate_full_expenses),
            expense_sheets: expense_sheets.map do |expense_sheet|
              extract_to_json(expense_sheet, :id)
                .merge(total: expense_sheet.total)
                .merge(user: expected_user_response)
            end
          }
        end

        it_behaves_like 'renders a successful http status code'

        it 'returns a content type json' do
          request
          expect(response.headers['Content-Type']).to include 'json'
        end

        it 'renders the correct response' do
          request
          expect(parse_response_json(response)).to eq(expected_response)
        end

        it 'changes expense_sheets states' do
          expect { request }.to change { expense_sheets.map(&:reload).map(&:state).uniq }.to ['payment_in_progress']
        end

        it 'changes expense_sheets payment_timestamps' do
          expect { request }
            .to change { expense_sheets.map(&:reload).map(&:payment_timestamp).uniq }.to [payment_timestamp]
        end
      end

      context 'when there are no expense sheets' do
        it_behaves_like 'renders a not found error response'
      end
    end

    context 'when user is a civil servant' do
      before { sign_in user }

      it_behaves_like 'admin protected resource'
    end

    context 'when no user is logged in' do
      it_behaves_like 'login protected resource'
    end
  end

  describe '#index' do
    let(:request) { get v1_payments_path }

    context 'when user is an admin' do
      let(:user) { create :user, :admin }

      before { sign_in user }

      context 'when there are payments' do
        let!(:payments) do
          iota = 0
          payment_in_progress_payments = Array.new(4).map do
            iota += 1
            create_payment payment_timestamp: Time.zone.now + iota.hours
          end
          paid_payments = Array.new(4).map do
            iota += 1
            create_payment state: :paid, payment_timestamp: Time.zone.now + iota.hours
          end

          payment_in_progress_payments.push(*paid_payments)
        end

        let(:expected_user_attributes) { %i[id zdp bank_iban] }
        let(:expected_user_response) do
          extract_to_json(user, *expected_user_attributes).merge(full_name: user.full_name)
        end
        let(:expected_response) do
          payments.map do |payment|
            {
              payment_timestamp: payment.payment_timestamp.to_i,
              state: payment.state.to_s,
              total: payment.total
            }
          end
        end

        before do
          create :service, user: user, beginning: beginning, ending: ending
        end

        it_behaves_like 'renders a successful http status code'

        it 'returns a content type json' do
          request
          expect(response.headers['Content-Type']).to include 'json'
        end

        it 'renders the correct response' do
          request
          expect(parse_response_json(response)).to eq(expected_response)
        end
      end

      context 'when there are no payments' do
        it 'returns an empty array' do
          request
          expect(parse_response_json(response)).to eq []
        end
      end
    end

    context 'when user is a civil servant' do
      before { sign_in user }

      it_behaves_like 'admin protected resource'
    end

    context 'when no user is logged in' do
      it_behaves_like 'login protected resource'
    end
  end
end
