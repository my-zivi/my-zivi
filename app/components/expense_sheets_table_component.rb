# frozen_string_literal: true

class ExpenseSheetsTableComponent < ViewComponent::Base
  COLUMNS = {
    full_name: {
      label: I18n.t('activerecord.models.civil_servant'),
      content: ->(expense_sheet, _helpers) { expense_sheet.civil_servant.full_name }
    },
    beginning: {
      label: I18n.t('activerecord.attributes.expense_sheet.beginning'),
      content: ->(expense_sheet, _helpers) { I18n.l(expense_sheet.beginning) }
    },
    ending: {
      label: I18n.t('activerecord.attributes.expense_sheet.ending'),
      content: ->(expense_sheet, _helpers) { I18n.l(expense_sheet.ending) }
    },
    duration: {
      label: I18n.t('organizations.expense_sheets.index.duration'),
      content: ->(expense_sheet, _helpers) { expense_sheet.duration }
    },
    amount: {
      label: I18n.t('activerecord.attributes.expense_sheet.amount'),
      content: lambda { |expense_sheet, _helpers|
        ActiveSupport::NumberHelper.number_to_currency(expense_sheet.amount, locale: 'de-CH')
      }
    },
    state: {
      label: I18n.t('activerecord.attributes.expense_sheet.state'),
      content: ->(expense_sheet, helpers) { helpers.expense_sheet_state_badge(expense_sheet.state) }
    }
  }.freeze

  def initialize(expense_sheets:, columns: COLUMNS)
    @expense_sheets = expense_sheets
    @columns = columns

    super
  end
end
