# frozen_string_literal: true

module Pdfs
  module ExpenseSheet
    module TableGenerator
      include TableHeader
      include TableSupplement
      include TableFooter

      def expense_table
        indent(10) do
          move_down 50
          draw_expense_table_headers
          move_down 35
          draw_expense_table_row
          draw_supplement_rows
          move_down 20
          draw_table_footer
        end
      end

      private

      def draw_expense_table_row
        Fields::ExpenseTable::DAY_ROWS.each do |row|
          count = row[:count].call(@expense_sheet)
          title = I18n.t(row[:header_title_key], count: count)

          draw_row_head([count.to_s, title])
          draw_row_content(row[:calculation_method])
          move_down 20
        end
      end

      def draw_row_head(headers)
        headers.each.with_index.reduce(bounds.left) do |global_indent, (content, index)|
          current_indent = Fields::ExpenseTable::COLUMN_WIDTHS[0]
          draw_row_head_text(global_indent, content, index)
          global_indent + current_indent
        end
      end

      def draw_row_head_text(global_indent, content, index)
        current_indent = Fields::ExpenseTable::COLUMN_WIDTHS[index]
        current_width = current_indent - (index.even? ? 2 : 0)
        current_align = index.even? ? :right : :left

        cursor_save_text_box(
          content, style: :bold, align: current_align,
                   at: [global_indent, cursor], width: current_width,
                   overflow: :shrink_to_fit, height: 15
        )
        global_indent + current_indent
      end

      def draw_row_content(calculation_method)
        header_indent = bounds.left + Fields::ExpenseTable::COLUMN_WIDTHS[0..1].sum + 5

        calculated_expenses = @expense_sheet.public_send(calculation_method)
        Fields::ExpenseTable::COLUMNS.each.with_index.reduce(header_indent) do |global_indent, (expense, index)|
          draw_row_content_box_and_text(global_indent,
                                        index,
                                        calculated_expenses[expense])
        end
      end

      def draw_row_content_box_and_text(global_indent, index, expense)
        current_indent = Fields::ExpenseTable::COLUMN_WIDTHS[index + 2]
        current_width = current_indent - 5
        last = Fields::ExpenseTable::COLUMNS.size == (index + 1)

        box Colors::GREY, [global_indent, (cursor + 3)], width: current_width, height: 15
        cursor_save_text_box(FormatHelper.to_chf(expense),
                             at: [(global_indent + 3), cursor],
                             width: (current_width - 8),
                             align: (last ? :right : :left))

        global_indent + current_indent
      end
    end
  end
end
