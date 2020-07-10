# frozen_string_literal: true

module Pdfs
  module ServiceAgreement
    class FormFiller
      FRENCH_FILE_PATH = Rails.root.join('lib/assets/pdfs/french_service_agreement_form.pdf').to_s.freeze
      GERMAN_FILE_PATH = Rails.root.join('lib/assets/pdfs/german_service_agreement_form.pdf').to_s.freeze

      LOCALIZE_FLAG = '|localize'

      def initialize(service)
        @service = service
      end

      def render
        fill_form
        pdf = pdf_file.read
        pdf_file.close
        pdf
        # pdf_file
      end

      private

      def fill_form
        # TODO: load language from user or civil_servant
        I18n.locale = false ? :fr : :de

        # TODO: load language from user or civil_servant
        fillable_pdf = FillablePDF.new false ? FRENCH_FILE_PATH : GERMAN_FILE_PATH
        # TODO: add french mapping version
        fields_mapping = false ? GermanFormFields::SERVICE_AGREEMENT_FIELDS : GermanFormFields::SERVICE_AGREEMENT_FIELDS
        fill_fields fillable_pdf, fields_mapping
        fillable_pdf.save_as(pdf_file.path, flatten: true)
        fillable_pdf.close
      end

      def pdf_file
        @pdf_file ||= Tempfile.new('service_agreement_form')
      end

      def fill_fields(pdf, fields_mapping)
        fields_mapping.each do |field_name, field_value_lambda|
          field_data = field_value_lambda.call @service
          pdf.set_field(field_name, field_data) if field_data # needed because '' for checkbox is true
        end
      end
    end
  end
end
