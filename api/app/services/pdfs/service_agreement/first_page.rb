# frozen_string_literal: true

module Pdfs
  module ServiceAgreement
    class FirstPage
      include Prawn::View
      include PrawnHelper

      def initialize(service)
        @service = service

        update_font_families

        generate_page
      end

      private

      def generate_page
        font_size 11 do
          indent 30 do
            header
            body
            footer
          end
        end
      end

      def header
        move_down 125
        global_indent = bounds.left
        [20, 275].each do |current_indent|
          global_indent += current_indent

          indent(global_indent) do
            cursor_save do
              draw_address_lines(header_sender_info)
            end
          end
        end
      end

      def header_sender_info
        [
          ENV['SERVICE_AGREEMENT_LETTER_SENDER_NAME'],
          ENV['SERVICE_AGREEMENT_LETTER_SENDER_ADDRESS'],
          ENV['SERVICE_AGREEMENT_LETTER_SENDER_ZIP_CITY']
        ]
      end

      def body
        move_down 180

        text_box(I18n.t('pdfs.service_agreement.body_content'), leading: 6.5, at: [bounds.left, cursor])
      end

      def footer
        move_down 250

        regional_center = @service.user.regional_center
        address_data = regional_center.address.split ', '

        indent 295 do
          draw_address_lines(address_data, 4.5)
        end
      end

      def document
        @document ||= Prawn::Document.new(page_size: 'A4')
      end

      def draw_address_lines(address_data, leading = 7)
        address_data.map do |address_line|
          text address_line.dup.force_encoding('utf-8')
          move_down leading
        end
      end
    end
  end
end
