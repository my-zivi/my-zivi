# frozen_string_literal: true

class ExpenseSheetsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def show
    respond_to do |format|
      format.pdf do
        send_data(Pdfs::ExpenseSheet::GeneratorService.new(@expense_sheet).render,
                  type: 'application/pdf',
                  disposition: 'inline')
      end
    end
  end
end
