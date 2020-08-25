# frozen_string_literal: true

module Organizations
  module PaymentsHelper
    def payment_badge(payment)
      render "organizations/payments/badges/#{payment.state}"
    end
  end
end
