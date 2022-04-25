# frozen_string_literal: true

module Pdfs
  module ExpenseSheet
    module Fields
      module ExpenseTable
        COLUMN_WIDTHS = [20, 85, 70, 70, 55, 55, 55, 65].freeze

        HEADERS = [
          I18n.t('activerecord.attributes.expense_sheet.pocket_money'),
          I18n.t('activerecord.attributes.expense_sheet.accommodation_expenses'),
          I18n.t('activerecord.attributes.service_specification.expense_keys.breakfast'),
          I18n.t('activerecord.attributes.service_specification.expense_keys.lunch'),
          I18n.t('activerecord.attributes.service_specification.expense_keys.dinner'),
          I18n.t('pdfs.expense_sheet.expense_table.headers.full_amount')
        ].freeze

        # false positive: Do not use symbol for lambda
        # rubocop:disable Lint/LambdaWithoutLiteralBlock
        DAY_ROWS = [
          {
            count: ->(expense_sheet) { expense_sheet.at_service_beginning? ? 1 : 0 },
            header_title_key: 'activerecord.attributes.expense_sheet.first_work_days',
            calculation_method: :calculate_first_day
          },
          {
            count: lambda(&:work_days_count),
            header_title_key: 'activerecord.attributes.expense_sheet.work_days',
            calculation_method: :calculate_work_days
          },
          {
            count: ->(expense_sheet) { expense_sheet.at_service_ending? ? 1 : 0 },
            header_title_key: 'activerecord.attributes.expense_sheet.last_work_days',
            calculation_method: :calculate_last_day
          },
          {
            count: lambda(&:workfree_days),
            header_title_key: 'activerecord.attributes.expense_sheet.workfree_days',
            calculation_method: :calculate_workfree_days
          },
          {
            count: lambda(&:sick_days),
            header_title_key: 'activerecord.attributes.expense_sheet.sick_days',
            calculation_method: :calculate_sick_days
          },
          {
            count: lambda(&:paid_vacation_days),
            header_title_key: 'activerecord.attributes.expense_sheet.paid_vacation_days',
            calculation_method: :calculate_paid_vacation_days
          },
          {
            count: lambda(&:unpaid_vacation_days),
            header_title_key: 'activerecord.attributes.expense_sheet.unpaid_vacation_days',
            calculation_method: :calculate_unpaid_vacation_days
          }
        ].freeze
        # rubocop:enable Lint/LambdaWithoutLiteralBlock

        COLUMNS = %i[pocket_money accommodation breakfast lunch dinner total].freeze

        include ExpenseTableAdditions
      end
    end
  end
end
