# frozen_string_literal: true

module ExpenseSheetStateMachine
  extend ActiveSupport::Concern

  included do
    validate :legitimate_state_change, if: :state_changed?
  end

  def legitimate_state_change
    return if editable_transition? || closed_transition?

    errors.add(:state, :invalid_state_change)
  end

  def editable_transition?
    state_was == 'locked' && state == 'editable'
  end

  def closed_transition?
    state_was == 'editable' && state == 'closed'
  end
end
