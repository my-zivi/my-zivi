# frozen_string_literal: true

class ExpenseSheetsTableComponent < ViewComponent::Base
  COLUMNS = {
    full_name: {
      label: I18n.t('activerecord.models.civil_servant'),
      content: ->(expense_sheet) { expense_sheet.civil_servant.full_name }
    },
    beginning: {
      label: I18n.t('activerecord.attributes.expense_sheet.beginning'),
      content: ->(expense_sheet) { I18n.l(expense_sheet.beginning) }
    },
    ending: {
      label: I18n.t('activerecord.attributes.expense_sheet.ending'),
      content: ->(expense_sheet) { I18n.l(expense_sheet.ending) }
    },
    duration: {
      label: I18n.t('organizations.expense_sheets.index.duration'),
      content: ->(expense_sheet) { expense_sheet.duration }
    }
  }.freeze

  def initialize(expense_sheets:, columns: COLUMNS)
    @expense_sheets = expense_sheets
    @columns = columns

    super
  end
end
