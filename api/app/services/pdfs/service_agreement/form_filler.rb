# frozen_string_literal: true

require 'pdf_forms'

module Pdfs
  module ServiceAgreement
    class FormFiller
      FRENCH_FILE_PATH = Rails.root.join('app', 'assets', 'pdfs', 'french_service_agreement_form.pdf').freeze
      GERMAN_FILE_PATH = Rails.root.join('app', 'assets', 'pdfs', 'german_service_agreement_form.pdf').freeze

      def initialize(service)
        @service = service
        @pdftk = PdfForms.new(ENV.fetch('PDFTK_BIN_PATH', '/usr/bin/pdftk'))
      end

      def render
        fill_form
        pdf = pdf_file.read
        pdf_file.close
        pdf_file.unlink
        pdf
      end

      private

      def fill_form
        I18n.locale = valais? ? :fr : :de

        file_path = valais? ? FRENCH_FILE_PATH : GERMAN_FILE_PATH

        @pdftk.fill_form file_path, pdf_file, load_fields, flatten: true
      end

      def pdf_file
        @pdf_file ||= Tempfile.new('service_agreement_form')
      end

      def load_fields
        load_user_fields
          .merge(load_service_date_fields)
          .merge(load_service_checkboxes)
          .merge(load_service_specification_fields)
          .merge(load_company_holiday_fields)
      end

      def load_user_fields
        convert_to_form_fields_hash(FormFields::USER_FORM_FIELDS) do |key, value|
          [value, @service.user.public_send(key)]
        end
      end

      def load_service_date_fields
        convert_to_form_fields_hash(FormFields::SERVICE_DATE_FORM_FIELDS) do |key, value|
          [value, I18n.l(@service.public_send(key))]
        end
      end

      def load_service_checkboxes
        convert_to_form_fields_hash(FormFields::SERVICE_CHECKBOX_FIELDS) do |key, value|
          [value, (@service.public_send(:"#{key}?") ? 'On' : 'Off')]
        end
      end

      def load_service_specification_fields
        convert_to_form_fields_hash(FormFields::SERVICE_SPECIFICATION_FORM_FIELDS) do |key, value|
          [value, @service.service_specification.public_send(key)]
        end
      end

      def load_company_holiday_fields
        company_holiday = Holiday.overlapping_date_range(@service.beginning, @service.ending)
                                 .select(&:company_holiday?).first
        return {} if company_holiday.nil?

        convert_to_form_fields_hash(FormFields::COMPANY_HOLIDAY_FORM_FIELDS) do |key, value|
          [value, I18n.l(company_holiday.public_send(key))]
        end
      end

      def convert_to_form_fields_hash(mapping, &block)
        mapping[I18n.locale].map(&block).to_h
      end

      def valais?
        @service.service_specification.location_valais?
      end
    end
  end
end
