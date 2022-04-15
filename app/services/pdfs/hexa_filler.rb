# frozen_string_literal: true

module Pdfs
  class HexaFiller
    def initialize(file_path)
      @file_path = file_path
      @doc = HexaPDF::Document.open(@file_path)
    end

    def set_field(name, data)
      form = @doc.acro_form
      field = form.field_by_name(name)
      field.field_value = data.to_s
    end

    def save_as(file_path)
      @doc.write(file_path, validate: false, incremental: false)
    end
  end
end
