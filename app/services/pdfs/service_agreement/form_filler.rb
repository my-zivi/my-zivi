# frozen_string_literal: true

module Pdfs
  module ServiceAgreement
    class FormFiller
      # FRENCH_FILE_PATH = Rails.root.join('lib/assets/pdfs/french_service_agreement_form.pdf').to_s.freeze
      # GERMAN_FILE_PATH = Rails.root.join('lib/assets/pdfs/german_service_agreement_form.pdf').to_s.freeze

      class << self
        def render(pdf_field_data, template_path)
          pdf_file = Tempfile.new('service_agreement_form')
          fill_form(pdf_field_data, template_path, pdf_file.path)
          pdf = pdf_file.read
          pdf_file.close
          pdf
        end

        private

        def fill_form(pdf_field_data, template_path, output_path)
          fillable_pdf = HexaFiller.new template_path
          fill_fields fillable_pdf, pdf_field_data
          fillable_pdf.save_as(output_path)
        end

        def fill_fields(pdf, pdf_field_data)
          pdf_field_data.each do |field_name, field_data|
            pdf.set_field(field_name, field_data) if field_data # needed because '' for checkbox is true
          end
        end
      end
    end
  end
end
