# frozen_string_literal: true

require 'hexapdf'

module Pdfs
  module ServiceAgreement
    class PdfCombineService
      def initialize(service)
        @service = service
        @combined = HexaPDF::Document.new
      end

      def render
        fill_and_load_form

        pdf_io = StringIO.new
        @combined.write(pdf_io)
        pdf_io.string
      end

      private

      def fill_and_load_form
        ioify_and_combine(FormFiller.new(@service))
      end

      def ioify_and_combine(pdf)
        pdf_path = pdf.render
        pdf_io = StringIO.new(pdf_path)

        HexaPDF::Document.new(io: pdf_io).pages.each { |page| @combined.pages << @combined.import(page) }
      end

      # TODO: Reimplement with uploaded file
      # def load_info_text
      #   HexaPDF::Document.open(
      #     valais? ? FRENCH_FILE_PATH : GERMAN_FILE_PATH
      #   ).pages.each { |page| @combined.pages << @combined.import(page) }
      # end
    end
  end
end
