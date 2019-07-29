# frozen_string_literal: true

module V1
  class PaymentsController < FileController
    include V1::Concerns::AdminAuthorizable

    before_action :authorize_admin!
    before_action :set_expense_sheet, only: :show

    def show
      respond_to do |format|
        format.xml do
          render plain: generate_pain, content_type: :xml
        end
      end
    end

    private

    def set_expense_sheet
      @sheets = ExpenseSheet.includes(:user).ready_for_payment
    end

    def generate_pain
      PainGenerationService.new(@sheets).generate_pain.to_xml('pain.001.001.03.ch.02')
    end
  end
end
