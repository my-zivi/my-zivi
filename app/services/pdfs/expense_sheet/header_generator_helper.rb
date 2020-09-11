# frozen_string_literal: true

module Pdfs
  module ExpenseSheet
    module HeaderGeneratorHelper
      def header
        box ::Pdfs::ExpenseSheet::Colors::GREEN, [0, cursor], width: bounds.width, height: 30
        move_down 30
        text_box header_title,
                 align: :center,
                 valign: :center,
                 style: :bold,
                 overflow: :shrink_to_fit,
                 height: 30,
                 single_line: true
      end

      def header_title
        I18n.t('pdfs.expense_sheet.header',
               identification_number: organization.identification_number,
               single_line_address: organization.address.full_compose(' '))
      end

      private

      def organization
        @expense_sheet.service_specification.organization
      end
    end
  end
end
