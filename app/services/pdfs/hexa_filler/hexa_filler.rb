# frozen_string_literal: true

module Pdfs
    class HexaFiller
      def initialize(file_path)
        @file_path = file_path
        @doc = HexaPDF::Document.open(file)
      end

      def set_field(name, data)
        form = @doc.acro_form
        field = form.field_by_name(name)
        field.field_value = value
      end

      def save_as(file_path, flatten: false)
        @doc.write(file_path, validate: false, incremental: false)
      end

      def close

      end

    end
end
