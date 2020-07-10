# frozen_string_literal: true

module ServiceAgreementForm
  class FieldPreparer
    class << self
      def prepare_fields(pdf_file, rename_mapping)
        rename_fields(FillablePDF.new(pdf_file), rename_mapping)
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
