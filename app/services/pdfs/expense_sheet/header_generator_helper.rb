# frozen_string_literal: true

module Pdfs
  module ExpenseSheet
    module HeaderGeneratorHelper
      def header
        box Colors::GREEN, [0, cursor], width: bounds.width, height: 30
        move_down 30
        text_box I18n.t('pdfs.expense_sheet.header'),
                 align: :center,
                 valign: :center,
                 style: :bold,
                 overflow: :shrink_to_fit,
                 height: 30,
                 single_line: true
      end
    end
  end
end
