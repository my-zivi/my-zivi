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
        'RobotoCondensed' => {
          normal: font_file_path('RobotoCondensed-Regular.ttf'),
          bold: font_file_path('RobotoCondensed-Bold.ttf'),
          italic: font_file_path('RobotoCondensed-RegularItalic.ttf')
        }
      )
      font 'RobotoCondensed'
    end

    private

    def font_file_path(filename)
      Rails.root.join('app', 'assets', 'fonts', filename)
    end
  end
end
