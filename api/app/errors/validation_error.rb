# frozen_string_literal: true

class ValidationError < StandardError
  attr_reader :validation_errors, :human_readable_descriptions

  def initialize(validation_errors, human_readable_descriptions = nil)
    @validation_errors = validation_errors.try(:messages)&.to_h || validation_errors.to_h
    @human_readable_descriptions = human_readable_descriptions
    @human_readable_descriptions ||= validation_errors.full_messages
  end

  def to_h
    {
      errors: @validation_errors,
      human_readable_descriptions: @human_readable_descriptions
    }
  end

  def merge!(other_validation_error)
    @validation_errors.merge! other_validation_error.validation_errors
    @human_readable_descriptions.push(*other_validation_error.human_readable_descriptions)
  end

  def empty?
    @validation_errors.empty? && @human_readable_descriptions.empty?
  end
end
