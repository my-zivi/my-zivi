module DateTimePickerHelper
  DEFAULT_OPTIONS = {
    dateFormat: 'd.m.Y',
    weekNumbers: true
  }.freeze

  def date_picker(form, placeholder = nil)
    form.input :range, input_html: {
      type: 'date', class: 'datetimepicker', data: { options: date_picker_options(placeholder) }
    }
  end

  def range_date_picker(form, **options)
    form.input :range, input_html: {
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
    DEFAULT_OPTIONS.merge(mode: 'range').merge(options).to_json
  end
end
