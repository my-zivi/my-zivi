# frozen_string_literal: true

module Pdfs
  module ServiceAgreement
    class FormFiller
      FRENCH_FILE_PATH = Rails.root.join('lib/assets/pdfs/french_service_agreement_form.pdf').to_s.freeze
      GERMAN_FILE_PATH = Rails.root.join('lib/assets/pdfs/german_service_agreement_form.pdf').to_s.freeze

      def initialize(service)
        @service = service
      end

      def render
        fill_form
        pdf_file
      end

      private

      def fill_form
        # TODO: load language from user or civil_servant
        I18n.locale = false ? :fr : :de

        # TODO: load language from user or civil_servant
        fillable_pdf = FillablePDF.new false ? FRENCH_FILE_PATH : GERMAN_FILE_PATH
        fillable_pdf.set_fields load_fields
        fillable_pdf.save_as(pdf_file, flatten: true)
      end

      def pdf_file
        @pdf_file ||= Tempfile.new('service_agreement_form')
      end

      def load_fields
        load_civil_servant_fields
          .merge(load_civil_servant_user_fields)
          .merge(load_civil_servant_address_fields)
          .merge(load_service_date_fields)
          .merge(load_service_checkboxes)
          .merge(load_service_specification_fields)
          .merge(load_company_holiday_fields)
      end

      def load_civil_servant_fields
        convert_to_form_fields_hash(FormFields::CIVIL_SERVANT_FORM_FIELDS) do |key, value|
          [value, @service.civil_servant.public_send(key)]
        end
      end

      def load_civil_servant_user_fields
        convert_to_form_fields_hash(FormFields::CIVIL_SERVANT_USER_FORM_FIELDS) do |key, value|
          [value, @service.civil_servant.user.public_send(key)]
        end
      end

      def load_civil_servant_address_fields
        convert_to_form_fields_hash(FormFields::CIVIL_SERVANT_ADDRESS_FORM_FIELDS) do |key, value|
          [value, @service.civil_servant.address.public_send(key)]
        end
      end

      def load_service_date_fields
        convert_to_form_fields_hash(FormFields::SERVICE_DATE_FORM_FIELDS) do |key, value|
          [value, I18n.l(@service.public_send(key))]
        end
      end

      def load_service_checkboxes
        convert_to_form_fields_hash(FormFields::SERVICE_CHECKBOX_FIELDS) do |key, value|
          [value, @service.public_send(:"#{key}?")]
        end
      end

      def load_service_specification_fields
        convert_to_form_fields_hash(FormFields::SERVICE_SPECIFICATION_FORM_FIELDS) do |key, value|
          [value, @service.service_specification.public_send(key)]
        end
      end

      def load_company_holiday_fields
        company_holiday = OrganizationHoliday.overlapping_date_range(@service.beginning, @service.ending)
        return {} if company_holiday.empty?

        convert_to_form_fields_hash(FormFields::COMPANY_HOLIDAY_FORM_FIELDS) do |key, value|
          [value, I18n.l(company_holiday.public_send(key))]
        end
      end

      def convert_to_form_fields_hash(mapping, &block)
        mapping[I18n.locale].map(&block).to_h
      end
    end
  end
end
