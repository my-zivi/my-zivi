# frozen_string_literal: true

class ExpenseSheetsController < ApplicationController
  include RespondWithPdfConcern

  before_action :authenticate_user!
  load_and_authorize_resource

  def show
    respond_to do |format|
      format.pdf { respond_with_pdf Pdfs::ExpenseSheet::GeneratorService.new(@expense_sheet).render }
    end
  end
end
