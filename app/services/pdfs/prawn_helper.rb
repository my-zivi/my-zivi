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
        'Ubuntu' => {
          normal: font_file_path('Ubuntu-Regular.ttf'),
          bold: font_file_path('Ubuntu-Bold.ttf'),
          italic: font_file_path('Ubuntu-Italic.ttf')
        }
      )
      font 'Ubuntu'
    end

    private

    def font_file_path(filename)
      Rails.root.join('app/javascript/fonts/ubuntu', filename)
    end
  end
end
