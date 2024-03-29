# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organizations::PaymentsController, type: :request do
  subject { response }

  let(:organization) { create :organization, :with_admin }

  describe '#index' do
    let(:perform_request) { get organizations_payments_path }
    let!(:payments) { create_pair(:payment, organization: organization) }
    let!(:outside_payment) { create(:payment, created_at: '2020-01-01') }

    around do |spec|
      I18n.with_locale(:'de-CH') { spec.run }
    end

    context 'when an organization administrator is signed in' do
      let(:organization_administrator) { create :organization_member, organization: organization }

      before { sign_in organization_administrator.user }

      it_behaves_like 'validates presence of breadcrumbs' do
        let(:expected_breadcrumbs) do
          [I18n.t('loaf.breadcrumbs.organizations.payments.index')]
        end

        before { perform_request }
      end

      it 'returns http success' do
        perform_request
        expect(response).to have_http_status(:success)
        expect(response).to render_template 'organizations/payments/index'
        expect(response.body).to include I18n.l(payments.first.created_at.to_date)
        expect(response.body).not_to include I18n.l(outside_payment.created_at.to_date)
      end
    end

    it_behaves_like 'admin subscription route only'
  end

  describe '#new' do
    let(:perform_request) { get new_organizations_payment_path }

    context 'when an organization administrator is signed in' do
      let(:organization_administrator) { create(:organization_member, organization: organization) }

      before { sign_in organization_administrator.user }

      it_behaves_like 'validates presence of breadcrumbs' do
        let(:expected_breadcrumbs) do
          [
            I18n.t('loaf.breadcrumbs.organizations.payments.index'),
            I18n.t('loaf.breadcrumbs.organizations.payments.new')
          ]
        end

        before { perform_request }
      end

      it 'returns successful response' do
        perform_request
        expect(response).to have_http_status(:ok)
        expect(response).to render_template 'organizations/payments/new'
        expect(response.body).to include I18n.t('organizations.payments.new.title')
      end

      describe 'expense sheets selection' do
        let(:outside_organization) { create(:organization, :with_admin) }
        let(:civil_servants) do
          [
            create(:civil_servant, :full, :with_service,
                   first_name: 'Peter',
                   last_name: 'Parker',
                   organization: organization),
            create(:civil_servant, :full, :with_service,
                   first_name: 'Christof',
                   last_name: 'Stiefel',
                   organization: organization),
            create(:civil_servant, :full, :with_service,
                   first_name: 'Tina',
                   last_name: 'Parker',
                   organization: organization),
            create(:civil_servant, :full, :with_service,
                   first_name: 'Tony',
                   last_name: 'Stark',
                   organization: outside_organization)
          ]
        end

        before do
          payment = create(:payment, organization: organization)

          create(:expense_sheet, :with_service, service: civil_servants.first.services.first)
          create(:expense_sheet, :with_service, service: civil_servants.second.services.first, payment: payment)
          create(:expense_sheet, :with_service, :locked, service: civil_servants.third.services.first)
          create(:expense_sheet, :with_service, service: civil_servants.fourth.services.first)
        end

        it 'only shows editable and accessible expense sheets', :without_bullet do
          perform_request
          expect(response.body).to include 'Peter Parker'
          expect(response.body).not_to include 'Tina Parker', 'Christof Stiefel', 'Tony Stark'
        end
      end
    end

    it_behaves_like 'admin subscription route only'
  end

  describe '#create' do
    let(:perform_request) { post organizations_payments_path(params: params) }
    let(:params) { { payment: { expense_sheet_ids: expense_sheet_ids } } }

    context 'when an organization administrator is signed in' do
      let(:organization_administrator) { create(:organization_member, organization: organization) }
      let(:expense_sheet_ids) { [expense_sheet.id] }
      let(:civil_servant) { create(:civil_servant, :full, :with_service, organization: organization) }
      let(:expense_sheet) { create(:expense_sheet, :with_service, service: civil_servant.services.first) }
      let(:created_payment) { Payment.order(:created_at).last }

      before { sign_in organization_administrator.user }

      it 'creates the payment' do
        expect { perform_request }.to(change { organization.payments.count })
        expect(created_payment.expense_sheets).to contain_exactly expense_sheet
        expect(created_payment.amount).to eq expense_sheet.amount
        expect(response).to redirect_to organizations_payment_path(created_payment)
        expect(flash[:success]).to eq I18n.t('organizations.payments.create.successful_create')
      end

      context 'when payment is invalid' do
        let(:expense_sheet_ids) { [''] }

        it 'does not create the payment' do
          expect { perform_request }.not_to change(Payment, :count)
          expect(response).to render_template 'organizations/payments/new'
          expect(flash[:error]).to eq I18n.t('organizations.payments.create.erroneous_create')
        end
      end
    end

    it_behaves_like 'admin subscription route only' do
      let(:expense_sheet_ids) { [''] }
    end
  end

  describe '#show' do
    let(:perform_request) { get organizations_payment_path(payment) }
    let(:civil_servant) { create(:civil_servant, :full, :with_service) }
    let(:service) { civil_servant.services.first }
    let(:expense_sheets) { ExpenseSheetGenerator.new(service).create_expense_sheets! }
    let(:payment) do
      create(:payment, organization: organization, created_at: service.ending, expense_sheets: expense_sheets)
    end

    context 'when an organization administrator is signed in' do
      let(:organization_administrator) { create(:organization_member, organization: organization) }

      before { sign_in organization_administrator.user }

      it_behaves_like 'validates presence of breadcrumbs' do
        let(:expected_breadcrumbs) do
          [
            I18n.t('loaf.breadcrumbs.organizations.payments.index'),
            I18n.t('loaf.breadcrumbs.organizations.payments.show', date: I18n.l(payment.created_at.to_date))
          ]
        end

        before { perform_request }
      end

      it 'returns a detail view of the payment', :without_bullet do
        perform_request
        expect(response).to have_http_status(:success)
        expect(response).to render_template 'organizations/payments/show'
        expect(response.body).to include(
          I18n.t('organizations.payments.show.title', date: I18n.l(service.ending.to_date))
        )
      end

      context 'when requesting the PAIN XML' do
        let(:perform_request) { get organizations_payment_path(payment, format: :xml) }

        before { allow(PainGenerationService).to receive(:call).and_call_original }

        it 'returns the XML' do
          perform_request
          expect(response).to have_http_status(:success)
          expect(response.content_type).to eq 'application/xml'
          expect(PainGenerationService).to have_received(:call)
        end

        context 'when PAIN generation causes an error' do
          let(:exception) { StandardError.new('failure') }

          before do
            allow(PainGenerationService).to receive(:call).and_raise(exception)
            stub_const('Sentry', instance_double('Sentry', capture_exception: true))
          end

          it 'tracks the error with additional context on Sentry' do
            expect { perform_request }.to raise_exception StandardError
            expect(Sentry).to have_received(:capture_exception).with(exception, extra: hash_including(
              action: be_a(String),
              payment_id: payment.id
            ))
          end
        end
      end

      context 'when trying to access a payment from a different organization' do
        let(:payment) { create(:payment) }

        before { perform_request }

        it_behaves_like 'unauthorized request'
      end
    end

    context 'when user is not allowed to access' do
      let(:service) { create(:service) }

      it_behaves_like 'admin subscription route only'
    end
  end

  describe '#update' do
    let(:payment) { create(:payment, organization: organization) }
    let(:perform_request) { patch organizations_payment_path(payment, params: { payment: payment_params }) }
    let(:payment_params) { {} }

    context 'when an organization administrator is signed in' do
      let(:organization_administrator) { create(:organization_member, organization: organization) }

      before { sign_in organization_administrator.user }

      context 'with valid state update params' do
        let(:payment_params) { { state: 'paid' } }

        it 'updates the payment' do
          expect { perform_request }.to(change { payment.reload.state }.and(change { payment.reload.paid_timestamp }))
          expect(response).to have_http_status(:found)
          expect(flash[:success]).to eq I18n.t('organizations.payments.update.successful_update')
        end

        context 'when accessing a foreign payment' do
          let(:payment) { create(:payment) }

          it_behaves_like 'unauthorized request' do
            before { perform_request }
          end

          it 'does not touch the payment' do
            expect { perform_request }.not_to(change(payment, :reload))
          end
        end
      end

      context 'with invalid state update params' do
        let(:payment_params) { { state: 'open' } }
        let(:payment) { create(:payment, :paid, organization: organization) }

        it 'does not update' do
          expect { perform_request }.not_to(change(payment, :reload))
          expect(flash[:error]).to eq I18n.t('organizations.payments.update.erroneous_update')
        end
      end
    end

    it_behaves_like 'admin subscription route only'
  end

  describe '#destroy' do
    subject { response }

    let(:perform_request) { delete organizations_payment_path(payment) }
    let!(:payment) { create(:payment, organization: organization) }

    context 'when an organization administrator is signed in' do
      let(:organization_administrator) { create(:organization_member, organization: organization) }

      before { sign_in organization_administrator.user }

      it 'destroys the payment' do
        expect { perform_request }.to change(Payment, :count).by(-1)
        expect(flash[:success]).to eq I18n.t('organizations.payments.destroy.successful_destroy')
      end

      context 'when the payment is paid' do
        let(:payment) { create(:payment, :paid, organization: organization) }

        it 'does not destroy the payment' do
          expect { perform_request }.not_to change(Payment, :count)
          expect(flash[:error]).to eq I18n.t('organizations.payments.destroy.erroneous_destroy')
        end
      end

      context 'when trying to destroy a payment of a different organization' do
        let(:payment) { create(:payment) }

        it 'does not destroy the payment' do
          expect { perform_request }.not_to change(Payment, :count)
        end

        it_behaves_like 'unauthorized request' do
          before { perform_request }
        end
      end
    end

    it_behaves_like 'admin subscription route only'
  end
end
