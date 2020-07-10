# frozen_string_literal: true

module ServiceAgreementForm
  class FieldPreparer
    class << self
      def prepare_fields(pdf_file, rename_mapping)
        rename_fields(FillablePDF.new(pdf_file), rename_mapping)
      end

      def fill_fields_with_field_name(pdf_filename, new_filename = nil)
        new_filename = pdf_filename if new_filename.nil?

        pdf_file = FillablePDF.new pdf_filename
        pdf_file.names.each do |name|
          pdf_file.set_field(name, name)
        end
        pdf_file.save_as new_filename
        pdf_file.close
      end

      private

      def rename_fields(pdf, rename_mapping)
        pdf.names.each do |field_name|
          new_field_name = rename_mapping[field_name.to_s]

          pdf.rename_field(field_name, new_field_name) if new_field_name.present?
        end

        pdf.save
        pdf.close
      end
    end
  end
end
