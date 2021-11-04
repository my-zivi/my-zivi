# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organizations::ExpenseSheetsController, type: :request do
  describe '#index', :without_bullet do
    let(:perform_request) { get organizations_expense_sheets_path }
    let(:organization) { create :organization, :with_admin }

    let(:brigitte) { create(:civil_servant, :with_service, :full, first_name: 'Brigitte') }
    let(:peter) { create(:civil_servant, :with_service, :full, first_name: 'Peter') }
    let(:maria) { create(:civil_servant, :with_service, :full, organization: organization, first_name: 'Maria') }
    let(:paul) { create(:civil_servant, :with_service, :full, organization: organization, first_name: 'Paul') }

    let(:brigitte_service) { brigitte.services.first }
    let(:peter_service) { peter.services.first }
    let(:maria_service) { maria.services.first }
    let(:paul_service) { paul.services.first }

    before do
      create(:expense_sheet, :locked, service: brigitte_service,
                                      beginning: brigitte_service.beginning,
                                      ending: brigitte_service.ending)
      create(:expense_sheet, service: peter_service,
                             beginning: peter_service.beginning,
                             ending: peter_service.ending)
      create(:expense_sheet, :closed, service: maria_service,
                                      beginning: maria_service.beginning,
                                      ending: maria_service.ending)
      create(:expense_sheet, service: paul_service,
                             beginning: paul_service.beginning,
                             ending: paul_service.ending)
    end

    context 'when a organization administrator is signed in' do
      let(:organization_administrator) { create :organization_member, organization: organization }

      before { sign_in organization_administrator.user }

      it_behaves_like 'validates presence of breadcrumbs' do
        let(:expected_breadcrumbs) do
          [I18n.t('loaf.breadcrumbs.organizations.expense_sheets.index')]
        end

        before { perform_request }
      end

      it 'successfully fetches a list of expense sheets in the organization' do
        perform_request
        expect(response).to have_http_status(:success)
        expect(response.body).to include 'Paul'
        expect(response.body).not_to include 'Brigitte', 'Peter', 'Maria'
      end

      context 'when inactive services are turned on' do
        let(:perform_request) { get organizations_expense_sheets_path(filters: { show_all: 'true' }) }

        it 'fetches a list of all expense sheets in the organization' do
          perform_request
          expect(response.body).to include 'Paul', 'Maria'
          expect(response.body).not_to include 'Brigitte', 'Peter'
        end
      end
    end

    it_behaves_like 'admin subscription route only'
  end

  describe '#edit' do
    let(:perform_request) { get edit_organizations_expense_sheet_path(paul_expense_sheet) }
    let(:organization) { create :organization, :with_admin }

    let(:brigitte) { create(:civil_servant, :with_service, :full, first_name: 'Brigitte') }
    let(:maria) { create(:civil_servant, :with_service, :full, organization: organization, first_name: 'Maria') }
    let(:paul) { create(:civil_servant, :with_service, :full, organization: organization, first_name: 'Paul') }

    let(:brigitte_service) { brigitte.services.first }
    let(:maria_service) { maria.services.first }
    let(:paul_service) { paul.services.first }

    let(:brigitte_expense_sheet) do
      create(:expense_sheet, :locked, service: brigitte_service,
                                      beginning: brigitte_service.beginning,
                                      ending: brigitte_service.ending)
    end
    let(:maria_expense_sheet) do
      create(:expense_sheet, :closed, service: maria_service,
                                      beginning: maria_service.beginning,
                                      ending: maria_service.ending)
    end
    let(:paul_expense_sheet) do
      create(:expense_sheet, service: paul_service,
                             beginning: paul_service.beginning,
                             ending: paul_service.ending)
    end

    context 'when a organization administrator is signed in' do
      let(:organization_administrator) { create :organization_member, organization: organization }

      let(:expected_strings) do
        [
          'Paul', I18n.l(paul_expense_sheet.beginning),
          I18n.l(paul_expense_sheet.ending), paul_expense_sheet.service.eligible_paid_vacation_days,
          paul_expense_sheet.duration, paul_expense_sheet.work_days,
          paul_expense_sheet.clothing_expenses, paul_expense_sheet.clothing_expenses_comment
        ].map(&:to_s)
      end

      before { sign_in organization_administrator.user }

      it_behaves_like 'validates presence of breadcrumbs' do
        let(:expected_breadcrumbs) do
          [
            I18n.t('loaf.breadcrumbs.organizations.expense_sheets.index'),
            paul_expense_sheet.civil_servant.full_name
          ]
        end

        before { perform_request }
      end

      it 'successfully displays a expense sheet form in the organization' do
        perform_request
        expect(response).to have_http_status(:success)
        expect(response.body).to include(*expected_strings)
      end
    end

    context 'when a organization administrator from another organization is signed in' do
      let(:organization_administrator) { create :organization_member }

      before { sign_in organization_administrator.user }

      it_behaves_like 'unauthorized request' do
        before { perform_request }
      end
    end

    it_behaves_like 'admin subscription route only'
  end

  describe '#update' do
    let(:perform_request) do
      patch organizations_expense_sheet_path(paul_expense_sheet, params: { expense_sheet: update_params })
    end
    let(:organization) { create :organization, :with_admin }

    let(:paul) { create(:civil_servant, :with_service, :full, organization: organization, first_name: 'Paul') }
    let(:paul_service) { paul.services.first }
    let(:paul_expense_sheet) do
      create(:expense_sheet, service: paul_service,
                             beginning: paul_service.beginning,
                             ending: paul_service.ending)
    end

    let(:update_params) { { driving_expenses: 9350, workfree_days: 0, clothing_expenses_comment: 'Benzin' } }

    context 'when a organization administrator of the same organization is signed in' do
      let(:organization_administrator) { create :organization_member, organization: organization }

      before { sign_in organization_administrator.user }

      context 'when the expense sheet is editable' do
        context 'when the update params are valid' do
          it 'successfully updates' do
            expect { perform_request }
              .to(change { paul_expense_sheet.reload.slice(update_params.keys) }.to(update_params))
            expect(response).to redirect_to(edit_organizations_expense_sheet_path(paul_expense_sheet))
          end
        end

        context 'when the update params are invalid' do
          let(:update_params) { { driving_expenses: -550 } }

          it 'does not update' do
            expect { perform_request }.not_to(change { paul_expense_sheet.reload.slice(update_params.keys) })
            expect(response).to have_http_status(:success)
            expect(flash[:error]).to eq I18n.t('organizations.expense_sheets.update.erroneous_update')
          end
        end
      end

      context 'when the expense sheet is closed' do
        let(:paul_expense_sheet) do
          create(:expense_sheet, :closed,
                 service: paul_service,
                 beginning: paul_service.beginning,
                 ending: paul_service.ending)
        end

        it 'does raise a readOnly error on updating a closed expense sheet in the organization' do
          expect { perform_request }.to raise_error(ActiveRecord::ReadOnlyRecord)
        end
      end
    end

    context 'when a organization administrator from another organization is signed in' do
      let(:organization_administrator) { create :organization_member }

      before { sign_in organization_administrator.user }

      it_behaves_like 'unauthorized request' do
        before { perform_request }
      end
    end

    it_behaves_like 'admin subscription route only'
  end
end
