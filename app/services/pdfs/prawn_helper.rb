# frozen_string_literal: true

module Pdfs
  module PrawnHelper
    def cursor_save
      cursor.tap do |old_cursor|
        yield
        move_cursor_to old_cursor
      end
    end

    def update_font_families
      font_families.update(
        'Roboto' => {
          normal: font_file_path('Roboto-Regular.ttf'),
          bold: font_file_path('Roboto-Bold.ttf'),
          italic: font_file_path('Roboto-Italic.ttf')
        }
      )
      font 'Roboto'
    end

    private

    def font_file_path(filename)
      Rails.root.join('app/javascript/fonts', filename)
    end
  end
end
