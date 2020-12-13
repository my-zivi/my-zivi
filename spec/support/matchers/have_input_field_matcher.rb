# frozen_string_literal: true

module HaveInputFieldMatcher
  class HaveInputFieldMatcher
    def initialize(expected_input_field)
      @expected_input_field = expected_input_field.to_s
    end

    def matches?(view_content)
      @view_content = view_content.to_s
      matched_input = @view_content.match(build_regex)&.to_s
      return false if matched_input.nil?

      @with_value.present? ? contains_value?(matched_input) : true
    end

    def with_value(value)
      @with_value = value.to_s
      self
    end

    def failure_message
      "\nexpected: #{@view_content}\n     to include input field #{field_description}\n"
    end

    def failure_message_when_negated
      "\nexpected: #{@view_content}\n     not to include input field #{field_description}\n"
    end

    def description
      "has input field #{@expected_input_field}"
    end

    def diffable?
      false
    end

    private

    def field_description
      field = "[name=\"#{@expected_input_field}\"]"
      field = "#{field} with value #{@with_value}" if @with_value
      field
    end

    def contains_value?(matched_input)
      matched_input.match?(/value="#{Regexp.quote(@with_value)}"/)
    end

    def build_regex
      %r{<input[^>]* name="#{Regexp.quote(@expected_input_field)}"[^>]*/?>}im
    end
  end

  def have_input_field(field)
    HaveInputFieldMatcher.new(field)
  end
end
