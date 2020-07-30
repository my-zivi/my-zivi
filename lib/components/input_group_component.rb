# frozen_string_literal: true

# :nocov:
module InputGroup
  def prepend(_wrapper_options = nil)
    span_tag = tag.span(options[:prepend], class: 'input-group-text')
    template.tag.div(span_tag, class: 'input-group-prepend')
  end

  def append(_wrapper_options = nil)
    span_tag = tag.span(options[:append], class: 'input-group-text')
    template.tag.div(span_tag, class: 'input-group-append')
  end
end

SimpleForm.include_component(InputGroup)
# :nocov:
