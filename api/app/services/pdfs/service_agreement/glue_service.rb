# frozen_string_literal: true

require 'pdf_forms'
require 'hexapdf'

module Pdfs
  module ServiceAgreement
    class GlueService
      FRENCH_FILE_PATH = Rails.root.join('app/assets/pdfs/french_service_agreement_text.pdf').freeze
      GERMAN_FILE_PATH = Rails.root.join('app/assets/pdfs/german_service_agreement_text.pdf').freeze

      def initialize(service)
        @service = service
        @combined = HexaPDF::Document.new
      end

      def render
        generate_and_load_first_page
        fill_and_load_form
        load_info_text

        pdf_io = StringIO.new
        @combined.write(pdf_io)
        pdf_io.string
      end

      private

      def generate_and_load_first_page
        ioify_and_combine(FirstPage.new(@service))
      end

      def fill_and_load_form
        ioify_and_combine(FormFiller.new(@service))
      end

      def ioify_and_combine(pdf)
        pdf_io = StringIO.new(pdf.render)

        HexaPDF::Document.new(io: pdf_io).pages.each { |page| @combined.pages << @combined.import(page) }
      end

      def load_info_text
        HexaPDF::Document.open(
          valais? ? FRENCH_FILE_PATH : GERMAN_FILE_PATH
        ).pages.each { |page| @combined.pages << @combined.import(page) }
      end

      def valais?
        @service.service_specification.location_valais?
      end
    end
  end
end
