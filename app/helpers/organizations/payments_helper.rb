# frozen_string_literal: true

module Organizations
  module PaymentsHelper
    def payment_badge(payment)
      render "organizations/payments/badges/#{payment.state}"
    end

    # rubocop:disable Rails/OutputSafety
    def expense_sheet_collection_value(expense_sheet)
      <<~LABEL.squish.html_safe
        <strong>#{sanitize(expense_sheet.civil_servant.full_name, tags: [])}</strong>
        (#{l(expense_sheet.beginning)} - #{l(expense_sheet.ending)}, #{number_to_currency(expense_sheet.amount)})
      LABEL
    end
    # rubocop:enable Rails/OutputSafety
  end
end
