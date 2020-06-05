# frozen_string_literal: true

module Pdfs
  module ExpensesOverview
    class ExpensesOverviewTableParts
      def initialize(expense_sheet)
        @expense_sheet = expense_sheet
        @user = expense_sheet.user
      end

      def all_parts
        first_part + second_part + third_part + fourth_part + fifth_part + sixt_part
      end

      private

      def first_part
        [{ content: @user.zdp.to_s, align: :right },
         { content: (@user.last_name + ' ' + @user.first_name) },
         { content: (I18n.l(@expense_sheet.beginning, format: :short) + ' - ' +
           I18n.l(@expense_sheet.ending, format: :short)).to_s, align: :center }]
      end

      def second_part
        [
          { content: @expense_sheet.work_days.to_s, align: :right },
          { content: Pdfs::ExpenseSheet::FormatHelper.to_chf(all_work_days_total), align: :right },
          { content: @expense_sheet.workfree_days.to_s, align: :right }
        ]
      end

      def all_work_days_total
        @expense_sheet.calculate_work_days[:total] +
          @expense_sheet.calculate_first_day[:total] +
          @expense_sheet.calculate_last_day[:total]
      end

      def third_part
        [
          { content: Pdfs::ExpenseSheet::FormatHelper.to_chf(@expense_sheet.calculate_workfree_days[:total]),
            align: :right },
          { content: @expense_sheet.sick_days.to_s, align: :right },
          { content: Pdfs::ExpenseSheet::FormatHelper.to_chf(@expense_sheet.calculate_sick_days[:total]),
            align: :right },
          { content: @expense_sheet.paid_vacation_days.to_s, align: :right },
          { content: Pdfs::ExpenseSheet::FormatHelper.to_chf(@expense_sheet.calculate_paid_vacation_days[:total]),
            align: :right }
        ]
      end

      def fourth_part
        [{ content: @expense_sheet.unpaid_vacation_days.to_s, align: :right },
         { content: Pdfs::ExpenseSheet::FormatHelper.to_chf(@expense_sheet.calculate_unpaid_vacation_days[:total]),
           align: :right },
         { content: Pdfs::ExpenseSheet::FormatHelper.to_chf(@expense_sheet.driving_expenses), align: :right },
         { content: (@expense_sheet.work_days + @expense_sheet.workfree_days +
           @expense_sheet.paid_vacation_days + @expense_sheet.sick_days).to_s, align: :right }]
      end

      def fifth_part
        [
          { content: Pdfs::ExpenseSheet::FormatHelper.to_chf(@expense_sheet.clothing_expenses), align: :right },
          { content: Pdfs::ExpenseSheet::FormatHelper.to_chf(@expense_sheet.extraordinary_expenses), align: :right },
          { content: (@expense_sheet.work_days + @expense_sheet.workfree_days +
            @expense_sheet.paid_vacation_days + @expense_sheet.sick_days).to_s, align: :right }
        ]
      end

      def sixt_part
        [
          { content: Pdfs::ExpenseSheet::FormatHelper.to_chf(@expense_sheet.calculate_full_expenses.to_d),
            align: :right }
        ]
      end
    end
  end
end
