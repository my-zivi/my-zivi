# frozen_string_literal: true

module Organizations
  class ExpenseSheetsController < BaseController
    PERMITTED_PARAMS = %i[
      duration work_days
      workfree_days sick_days
      unpaid_company_holiday_days paid_company_holiday_days
      paid_vacation_days paid_vacation_comment
      unpaid_vacation_days unpaid_vacation_comment
      clothing_expenses clothing_expenses_comment
      driving_expenses driving_expenses_comment
      extraordinary_expenses extraordinary_expenses_comment
    ].freeze

    load_and_authorize_resource
    breadcrumb 'organizations.expense_sheets', :organizations_expense_sheets_path

    def index
      load_filters
      @expense_sheets = filtered_expense_sheets.order(ending: :desc, beginning: :desc)
    end

    def edit
      load_suggestions
      breadcrumb I18n.t('organizations.expense_sheets.edit.title_html',
                        name: @expense_sheet.civil_servant.full_name) + ' ' +
                 I18n.t('organizations.expense_sheets.edit.subtitle_html',
                        spec_name: @expense_sheet.service.service_specification.name,
                        beginning: l(@expense_sheet.service.beginning),
                        ending: l(@expense_sheet.service.ending)),
                 organizations_expense_sheets_path(@expense_sheet)
    end

    def update
      if @expense_sheet.update(expense_sheets_params)
        redirect_to edit_organizations_expense_sheet_path, notice: t('.successful_update')
      else
        load_suggestions
        flash[:error] = t('.erroneous_update')
        render :edit
      end
    end

    private

    def load_suggestions
      @suggestions = ExpenseSheetCalculators::SuggestionsCalculator.new(@expense_sheet).suggestions
    end

    def expense_sheets_params
      params.require(:expense_sheet).permit(*PERMITTED_PARAMS)
    end

    def filtered_expense_sheets
      @expense_sheets = @expense_sheets.includes(:civil_servant)

      return @expense_sheets if @filters[:show_all]

      @expense_sheets.editable
    end

    def load_filters
      @filters = {
        show_all: params.dig(:filters, :show_all) == 'true'
      }
    end
  end
end
