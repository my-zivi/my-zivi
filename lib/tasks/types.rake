# frozen_string_literal: true

def js_type(indentation, value)
  case value
  when String
    'string'
  when Array
    'string[]'
  else
    to_js_object(value, indentation + 2)
  end
end

def to_js_object(hash, indentation = 2)
  content = hash.map do |key, value|
    indent = ' ' * indentation

    "#{indent}#{key}: #{js_type(indentation, value)};"
  end

  base_indent = ' ' * (indentation - 2)

  "{\n#{content.join("\n")}\n#{base_indent}}"
end

namespace :types do
  desc 'Generates Typescript translation types'
  task generate: :environment do
    content = to_js_object(I18n.t('search').deep_transform_keys { |key| key.to_s.camelize(:lower) })

    template = <<~JS
      // Generated file using `rake types:generate`

      declare interface SearchTranslations #{content[..-1]}
    JS

    File.write(Rails.root.join('app/javascript/js/shared/SearchTranslations.d.ts'), template)
  end
end
