# frozen_string_literal: true

module Pdfs
  module ExpenseSheet
    module TableSupplement
      def draw_supplement_rows
        Fields::ExpenseTable::SUPPLEMENT_ROWS.each do |row|
          draw_supplement_row row
          move_down 20
        end
      end

      def draw_supplement_row(row)
        no_content = true
        row.each.reduce(bounds.left) do |global_indent, (indent, content)|
          content = safe_call_value(content)
          no_content &&= content.empty?

          draw_supplement_row_content(global_indent, indent, content)

          global_indent + indent
        end
        move_up 20 if no_content
      end

      def draw_supplement_row_content(global_indent, indent, content)
        header = (global_indent < (bounds.left + 105))
        header_padding = (header ? 0 : 5)
        current_indent = global_indent + header_padding
        current_width = indent - header_padding

        if header
          draw_supplement_header(content, current_indent, current_width)
        elsif content.present?
          box Colors::GREY, [current_indent, (cursor + 3)], width: current_width, height: 15
          font_size supplement_content_font_size(current_indent) do
            draw_supplement_content(content, current_indent, current_width)
          end
        end
      end

      def draw_supplement_header(content, current_indent, current_width)
        first = current_indent == bounds.left

        cursor_save_text_box(content,
                             at: [current_indent, cursor],
                             width: current_width - 3,
                             align: (first ? :right : :left),
                             style: :bold,
                             overflow: :shrink_to_fit,
                             height: 15)
      end

      # :reek:FeatureEnvy
      def supplement_box_content_config(full_indent, full_width)
        return {} unless last_supplement_box_column?(full_indent)

        {
          width: full_width - 6,
          align: :right,
          style: :italic
        }
      end

      private

      def draw_supplement_content(content, current_indent, current_width)
        cursor_save_text_box(
          content,
          default_supplement_box_content_config(current_indent, current_width)
            .merge(supplement_box_content_config(current_indent, current_width))
        )
      end

      def supplement_content_font_size(current_indent)
        last_supplement_box_column?(current_indent) ? 10 : 8
      end

      def default_supplement_box_content_config(full_indent, full_width)
        {
          at: [full_indent + 3, cursor],
          width: full_width - 6,
          overflow: :shrink_to_fit,
          height: 15,
          align: :left
        }
      end

      def last_supplement_box_column?(full_indent)
        (full_indent == Fields::ExpenseTable::COLUMN_WIDTHS[0..-2].sum + 5)
      end
    end
  end
end
