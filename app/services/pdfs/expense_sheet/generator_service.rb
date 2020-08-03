# frozen_string_literal: true

require 'prawn'

module Pdfs
  module ExpenseSheet
    class GeneratorService
      include Prawn::View
      include ::Pdfs::PrawnHelper
      include TableGenerator
      include HeaderGeneratorHelper
      include HeaderInfoBlockGenerator
      include TableGenerator
      include FooterInfoBlockGenerator
      include GeneratorServiceHelpers

      def initialize(expense_sheet)
        @expense_sheet = expense_sheet

        update_font_families

        header
        body
        footer
      end

      private

      def document
        @document ||= Prawn::Document.new(page_size: 'A4')
      end

      def body
        font_size 10 do
          header_info_block
          expense_table
        end
      end

      def footer
        font_size 10 do
          footer_info_block
        end
      end

      def box(color, pos, size)
        fill_color color
        fill_rectangle pos, size[:width], size[:height]
        fill_color Colors::BLACK
      end

      def cursor_save_text_box(*text_box_args)
        cursor_save do
          text_box(*text_box_args)
        end
      end
    end
  end
end
