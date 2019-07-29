# frozen_string_literal: true

module Pdfs
  module ExpenseSheet
    module TableHeader
      def draw_expense_table_headers
        header_indent = bounds.left + Fields::ExpenseTable::COLUMN_WIDTHS[0..1].sum + 5

        Fields::ExpenseTable::HEADERS.each.with_index.reduce(header_indent) do |global_indent, (header, index)|
          current_indent = Fields::ExpenseTable::COLUMN_WIDTHS[2..-1][index]

          draw_table_head_text(header, index, global_indent)
          global_indent + current_indent
        end
      end

      def draw_table_head_text(header, index, global_indent)
        last = index == (Fields::ExpenseTable::HEADERS.length - 1)
        current_indent = Fields::ExpenseTable::COLUMN_WIDTHS[2..-1][index]
        current_width = current_indent - (last ? 8 : 0) - 3
        current_align = last ? :right : :left

        text_box(header,
                 at: [global_indent + 2, cursor],
                 width: current_width,
                 align: current_align,
                 style: :bold,
                 overflow: :shrink_to_fit,
                 height: 15)
        text_box('(Fr.)', at: [global_indent + 2, cursor - 12], width: current_width, align: current_align)
      end
    end
  end
end
