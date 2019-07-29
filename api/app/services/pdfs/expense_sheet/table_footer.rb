# frozen_string_literal: true

module Pdfs
  module ExpenseSheet
    module TableFooter
      def draw_table_footer
        draw_table_footer_pre_lines
        move_down 8.5
        draw_table_footer_rows
        move_down 10
        draw_table_footer_post_lines
      end

      private

      def draw_table_footer_pre_lines
        line_width 0.5
        map_lines(Fields::ExpenseTable::FOOTER[:pre_line])
        line_width 1
      end

      def draw_table_footer_rows
        Fields::ExpenseTable::FOOTER[:content].each(&method(:draw_table_footer_row))
      end

      def draw_table_footer_row(row)
        row.each.with_index.reduce(bounds.left) do |global_indent, (footer_column, index)|
          last = row.length == index + 1

          draw_table_footer_row_content global_indent, footer_column, (last ? :right : :left)

          global_indent + footer_column[0]
        end
      end

      def draw_table_footer_row_content(global_indent, footer_column, align)
        indent = footer_column[0]
        content = footer_column[1]
        content = content.call(@expense_sheet).to_s if content.is_a? Proc

        return if content.blank?

        cursor_save_text_box(content,
                             at: [(global_indent + 3), cursor],
                             width: (indent - 8),
                             align: align,
                             style: :bold)
      end

      def draw_table_footer_post_lines
        map_lines(Fields::ExpenseTable::FOOTER[:post_line])
      end

      def map_lines(rows)
        rows.each(&method(:draw_line))
      end

      def draw_line(row)
        row.reduce(bounds.left) do |global_indent, line|
          draw_table_footer_line global_indent, line
          move_down 1.5

          global_indent + line[0]
        end
      end

      def draw_table_footer_line(global_indent, line)
        indent = line[0]

        stroke do
          horizontal_line(global_indent, global_indent + indent) if line[1].present?
        end
      end
    end
  end
end
