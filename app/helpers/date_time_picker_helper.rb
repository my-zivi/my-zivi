# frozen_string_literal: true

module DateTimePickerHelper
  DEFAULT_OPTIONS = {
    dateFormat: 'd.m.Y',
    weekNumbers: true
  }.freeze

  def date_picker(form, field_key, **options)
    form.input field_key, input_html: {
      type: 'date', class: 'datetimepicker', data: { options: date_picker_options(options) }
    }
  end

  def range_date_picker(form, field_key, **options)
    form.input field_key, input_html: {
      type: 'date', class: 'datetimepicker', data: { options: range_date_picker_options(options) }
    }
  end

  private

  def build_options(options)
    DEFAULT_OPTIONS.merge(options)
  end

  def date_picker_options(options)
    build_options(options).to_json
  end

  def range_date_picker_options(options)
    build_options(options.merge(mode: 'range')).to_json
  end
end
