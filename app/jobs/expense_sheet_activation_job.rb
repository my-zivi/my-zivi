# frozen_string_literal: true

class ExpenseSheetActivationJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    ExpenseSheet.locked.covering_date.each(&:editable!)
  end
end
