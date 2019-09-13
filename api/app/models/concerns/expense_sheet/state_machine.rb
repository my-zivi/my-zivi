# frozen_string_literal: true

module Concerns
  module ExpenseSheet
    module StateMachine
      extend ActiveSupport::Concern

      included do
        validate :legitimate_state_change, if: :state_changed?
      end

      def legitimate_state_change
        return if [
          state_ready_for_payment_or_open_to_ready_for_payment_or_open?,
          state_ready_for_payment_to_payment_in_progress?,
          state_payment_in_progress_to_paid_or_ready_for_payment?
        ].one?

        errors.add(:state, :invalid_state_change)
      end

      def state_ready_for_payment_or_open_to_ready_for_payment_or_open?
        state.in?(%w[open ready_for_payment]) && state_was.in?(%w[open ready_for_payment])
      end

      def state_ready_for_payment_to_payment_in_progress?
        state.in?(%w[payment_in_progress]) && state_was.in?(%w[ready_for_payment])
      end

      def state_payment_in_progress_to_paid_or_ready_for_payment?
        state.in?(%w[paid ready_for_payment]) && state_was.in?(%w[payment_in_progress])
      end
    end
  end
end
