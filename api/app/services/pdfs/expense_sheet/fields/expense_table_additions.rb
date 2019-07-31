# frozen_string_literal: true

module Pdfs
  module ExpenseSheet
    module Fields
      module ExpenseTableAdditions
        SUPPLEMENT_ROWS = [
          {
            ExpenseTable::COLUMN_WIDTHS[0..1].sum => '',
            ExpenseTable::COLUMN_WIDTHS[2..4].sum => lambda do |expense_sheet|
              return '' if expense_sheet.unpaid_vacation_comment.blank?

              I18n.t('pdfs.expense_sheet.expense_table.supplement.unpaid_vacation_comment',
                     comment: expense_sheet.unpaid_vacation_comment)
            end
          },
          {
            ExpenseTable::COLUMN_WIDTHS[0] => '+',
            ExpenseTable::COLUMN_WIDTHS[1] =>
              I18n.t('activerecord.attributes.expense_sheet.driving_expenses'),
            ExpenseTable::COLUMN_WIDTHS[2..4].sum => lambda do |expense_sheet|
              comment = expense_sheet.driving_expenses_comment
              return comment if comment.present?

              I18n.t('pdfs.expense_sheet.expense_table.supplement.driving_expenses_comment_empty')
            end,
            ExpenseTable::COLUMN_WIDTHS[5..-2].sum => '',
            ExpenseTable::COLUMN_WIDTHS[-1] => lambda do |expense_sheet|
              Pdfs::ExpenseSheet::FormatHelper.to_chf(expense_sheet.driving_expenses.to_d)
            end
          },
          {
            ExpenseTable::COLUMN_WIDTHS[0] => '+',
            ExpenseTable::COLUMN_WIDTHS[1] => I18n.t(
              'activerecord.attributes.expense_sheet.work_clothing_expenses'
            ),
            ExpenseTable::COLUMN_WIDTHS[2..4].sum => lambda do |expense_sheet|
              double_amount = expense_sheet.service.service_specification.work_clothing_expenses.to_d
              formatted_amount = Pdfs::ExpenseSheet::FormatHelper.to_chf(double_amount)

              I18n.t('pdfs.expense_sheet.expense_table.supplement.work_clothing_expenses_comment',
                     amount: formatted_amount,
                     count: expense_sheet.calculate_chargeable_days)
            end,
            ExpenseTable::COLUMN_WIDTHS[5..-2].sum => '',
            ExpenseTable::COLUMN_WIDTHS[-1] => lambda do |expense_sheet|
              Pdfs::ExpenseSheet::FormatHelper.to_chf(expense_sheet.calculate_work_clothing_expenses.to_d)
            end
          }
        ].freeze

        FOOTER = {
          pre_line: [
            { ExpenseTable::COLUMN_WIDTHS[0..-3].sum => '', ExpenseTable::COLUMN_WIDTHS[-2..-1].sum => '-' }
          ],
          content: [
            {
              ExpenseTable::COLUMN_WIDTHS[0..-3].sum => '',
              ExpenseTable::COLUMN_WIDTHS[-2] => "#{I18n.t('pdfs.expense_sheet.expense_table.footer.total')}:",
              ExpenseTable::COLUMN_WIDTHS[-1] => lambda do |expense_sheet|
                Pdfs::ExpenseSheet::FormatHelper.to_chf(expense_sheet.calculate_full_expenses.to_d)
              end
            }
          ],
          post_line: [
            { ExpenseTable::COLUMN_WIDTHS[0..-3].sum => '', ExpenseTable::COLUMN_WIDTHS[-2..-1].sum => '-' },
            { ExpenseTable::COLUMN_WIDTHS[0..-3].sum => '', ExpenseTable::COLUMN_WIDTHS[-2..-1].sum => '-' }
          ]
        }.freeze
      end
    end
  end
end
