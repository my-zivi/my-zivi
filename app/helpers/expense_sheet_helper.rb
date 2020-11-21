# frozen_string_literal: true

module ExpenseSheetHelper
  def expense_sheet_state_badge(expense_sheet_state)
    return unless ExpenseSheet.states.key? expense_sheet_state

    tag.div(
      enum_i18n(ExpenseSheet, :state, expense_sheet_state),
      class: "badge #{expense_sheet_state_badge_class(expense_sheet_state)}"
    )
  end

  private

  def expense_sheet_state_badge_class(expense_sheet_state)
    {
      'closed' => 'badge-success',
      'editable' => 'badge-primary',
      'locked' => 'badge-secondary'
    }.fetch(expense_sheet_state.to_s)
  end
end
