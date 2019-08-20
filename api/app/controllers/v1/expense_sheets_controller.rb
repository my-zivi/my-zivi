# frozen_string_literal: true

module V1
  class ExpenseSheetsController < ApplicationController
    include V1::Concerns::AdminAuthorizable
    include V1::Concerns::ParamsAuthenticatable

    before_action :authenticate_user!, unless: -> { request.format.pdf? }
    before_action :authenticate_from_params!, if: -> { request.format.pdf? }
    before_action :set_expense_sheet, only: %i[show update destroy hints]
    before_action :authorize_admin!

    PERMITTED_EXPENSE_SHEET_KEYS = %i[
      beginning ending work_days unpaid_company_holiday_days
      paid_company_holiday_days company_holiday_comment workfree_days
      sick_days sick_comment user_id
      paid_vacation_days paid_vacation_comment unpaid_vacation_days
      unpaid_vacation_comment driving_expenses driving_expenses_comment
      extraordinary_expenses extraordinary_expenses_comment clothing_expenses
      clothing_expenses_comment bank_account_number state
    ].freeze

    def index
      @expense_sheets = filtered_expense_sheets
    end

    def show
      respond_to do |format|
        format.json
        format.pdf do
          pdf = Pdfs::ExpenseSheet::GeneratorService.new(@expense_sheet)

          send_data pdf.render,
                    filename: I18n.t('pdfs.expense_sheet.filename', today: @expense_sheet.user.full_name),
                    type: 'application/pdf',
                    disposition: 'inline'
        end
      end
    end

    def hints
      suggestions = ExpenseSheetCalculators::SuggestionsCalculator.new(@expense_sheet).suggestions
      remaining_days = ExpenseSheetCalculators::RemainingDaysCalculator.new(@expense_sheet.service).remaining_days

      render :hints, locals: { suggestions: suggestions, remaining_days: remaining_days }
    end

    def create
      @expense_sheet = ExpenseSheet.new(expense_sheet_params)

      raise ValidationError, @expense_sheet.errors unless @expense_sheet.save

      render :show
    end

    # TODO: check state updates (does it already belong to a payment?)
    def update
      raise ValidationError, @expense_sheet.errors unless @expense_sheet.update(expense_sheet_params)

      render :show
    end

    def destroy
      raise ValidationError, @expense_sheet.errors unless @expense_sheet.destroy
    end

    private

    def filtered_expense_sheets
      case filter_param
      when 'current'
        ExpenseSheet.open.before_date(Time.zone.today.at_end_of_month + 1.day)
      when 'pending'
        ExpenseSheet.where(state: %i[open ready_for_payment])
      when 'ready_for_payment'
        ExpenseSheet.ready_for_payment
      else
        ExpenseSheet.all
      end
    end

    def set_expense_sheet
      @expense_sheet = ExpenseSheet.find(params[:id])
    end

    def expense_sheet_params
      params.require(:expense_sheet).permit(*PERMITTED_EXPENSE_SHEET_KEYS)
    end

    def filter_param
      params[:filter]
    end
  end
end
