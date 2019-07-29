# frozen_string_literal: true

module V1
  class ExpenseSheetsController < ApplicationController
    include V1::Concerns::AdminAuthorizable
    include V1::Concerns::ParamsAuthenticatable

    before_action :authenticate_user!, unless: -> { request.format.pdf? }
    before_action :authenticate_from_params!, if: -> { request.format.pdf? }
    before_action :set_expense_sheet, only: %i[show update destroy]
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
      @expense_sheets = ExpenseSheet.all
    end

    def show
      respond_to do |format|
        format.json
        format.pdf do
          I18n.locale = :de
          pdf = Pdfs::ExpenseSheet::GeneratorService.new(@expense_sheet)

          send_data pdf.render,
                    filename: I18n.t('pdfs.expense_sheet.filename', today: @expense_sheet.user.full_name),
                    type: 'application/pdf',
                    disposition: 'inline'
        end
      end
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

    def set_expense_sheet
      @expense_sheet = ExpenseSheet.find(params[:id])
    end

    def expense_sheet_params
      params.require(:expense_sheet).permit(*PERMITTED_EXPENSE_SHEET_KEYS)
    end
  end
end
