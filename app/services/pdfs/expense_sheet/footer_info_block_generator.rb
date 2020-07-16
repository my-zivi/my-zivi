# frozen_string_literal: true

module Pdfs
  module ExpenseSheet
    module FooterInfoBlockGenerator
      def footer_info_block
        move_down 25
        draw_footer_rows
      end

      def draw_footer_rows
        Fields::InfoBlock::FOOTER_ROWS.each do |row|
          label = row[:label]
          content = row[:content]

          label = label.call(@expense_sheet).to_s if label.is_a? Proc
          content = content.call(@expense_sheet).to_s if content.is_a? Proc

          draw_info_block_line(label, content)
          move_down 10
        end
      end
    end
  end
end
