# frozen_string_literal: true

module DateTimePickerHelper
  DEFAULT_OPTIONS = {
    dateFormat: 'd.m.Y',
    weekNumbers: true
  }.freeze

  RANGE_SPLITTERS = {
    fr: 'au',
    de: 'bis'
  }.freeze

  def date_picker(form, field_key, **options)
    form.input field_key, input_html: {
      type: 'date', disabled: true, class: 'datetimepicker', data: { options: date_picker_options(options) }
    }
  end

  def range_date_picker(form, field_key, value, **options)
    form.input field_key, input_html: {
      type: 'date', class: 'datetimepicker',
      value: value, readonly: true,
      data: { options: range_date_picker_options(options) }
    }
  end

  def parse_range_date(range_value)
    return nil if range_value.blank?

    dates = range_value.split(RANGE_SPLITTERS[I18n.locale])
    return nil if dates.count != 2

    beginning = Date.parse(dates.first)
    ending = Date.parse(dates.last)

    beginning..ending
  end

  private

  def build_options(options)
    DEFAULT_OPTIONS.merge(options).merge(locale: I18n.locale)
  end

  def date_picker_options(options)
    build_options(options).to_json
  end

  def range_date_picker_options(options)
    build_options(options.merge(mode: 'range')).to_json
  end
end
