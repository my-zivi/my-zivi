# frozen_string_literal: true

module Pdfs
  module ServiceAgreement
    class FormFiller
      FRENCH_FILE_PATH = Rails.root.join('lib/assets/pdfs/french_service_agreement_form.pdf').to_s.freeze
      GERMAN_FILE_PATH = Rails.root.join('lib/assets/pdfs/german_service_agreement_form.pdf').to_s.freeze

      LOCALIZE_FLAG = '|localize'.freeze

      def initialize(service)
        @service = service
      end

      def render
        fill_form
        pdf_file.read
        # pdf_file.close
        # pdf
      end

      private

      def fill_form
        # TODO: load language from user or civil_servant
        I18n.locale = false ? :fr : :de

        # TODO: load language from user or civil_servant
        fillable_pdf = FillablePDF.new false ? FRENCH_FILE_PATH : GERMAN_FILE_PATH
        fill_fields fillable_pdf
        fillable_pdf.save_as(pdf_file.path, flatten: true)
        fillable_pdf.close
      end

      def pdf_file
        @pdf_file ||= Tempfile.new('service_agreement_form')
      end

      def fill_fields(pdf)
        base_objects = {
          service: @service,
          organization_holiday: nil
        }

        pdf.names.each do |field_definition|
          field_data = load_field_data(field_definition.to_s, base_objects)
          pdf.set_field(field_definition, field_data)
        end
      end

      def load_field_data(field_definition, base_objects)
        field_paths = field_definition.split('.')
        return '' if field_paths.blank?

        base_object_path = field_paths.shift
        return '' if base_object_path.blank?

        object_localized = field_paths.last&.end_with?(LOCALIZE_FLAG) || false
        field_paths.last.sub! LOCALIZE_FLAG, '' if object_localized

        base_object = base_objects[base_object_path.to_sym]
        raw_value = get_x_deep_value(base_object, field_paths)
        object_localized ? I18n.l(raw_value) : raw_value
      end

      def get_x_deep_value(base_object, attribute_path)
        return '' if base_object.nil?

        object = base_object
        attribute_path.each do |key|
          return '' unless object.respond_to? key

          object = object.public_send(key)
        end
        object
      end

      def convert_to_form_fields_hash(mapping, &block)
        mapping[I18n.locale].map(&block).to_h
      end
    end
  end
end
