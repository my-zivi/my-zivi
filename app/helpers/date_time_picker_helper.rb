# frozen_string_literal: true

module DateTimePickerHelper
  DEFAULT_OPTIONS = {
    dateFormat: 'd.m.Y',
    weekNumbers: true
  }.freeze

  RANGE_SPLITTERS = {
    "fr-CH": ' au ',
    "de-CH": ' bis '
  }.freeze

  # :reek:BooleanParameter
  def date_picker(form, field_key, value, required: false, **date_picker_options)
    form.input field_key, as: :string, input_html: {
      type: 'date',
      value: localize_date(value),
      class: 'datetimepicker',
      data: { options: date_picker_options(date_picker_options, value) }
    }, required: required
  end

  # :reek:BooleanParameter
  def range_date_picker(form, field_key, value, required: false, **date_picker_options)
    form.input field_key, input_html: {
      type: 'date',
      class: 'datetimepicker',
      value: value,
      readonly: true,
      data: { options: range_date_picker_options(date_picker_options, parse_range_date(value)) }
    }, required: required
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

  def localize_date(date)
    return '' if date.nil?

    date.iso8601
  end

  def build_options(custom_options)
    options = { locale: I18n.locale }
    DEFAULT_OPTIONS.merge(**options, **custom_options)
  end

  def date_picker_options(options, value)
    options[:defaultDate] = l(value) if value.present?
    build_options(options).to_json
  end

  def range_date_picker_options(options, value)
    default_date = range_date_picker_default_date(value)
    options[:defaultDate] = default_date if default_date
    build_options(options.merge(mode: 'range')).to_json
  end

  def range_date_picker_default_date(value)
    return nil if value.nil?

    range = [value.begin, value.end].compact
    return nil if range.empty?

    range.map { |date| l(date) }
  end
end
