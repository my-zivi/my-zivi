# frozen_string_literal: true

# :nocov:
class RegistrationStepColumn < ActiveModel::Type::ImmutableString
  def cast(value)
    return nil if value.blank?
    return value if value.is_a?(RegistrationStep)

    RegistrationStep.new(identifier: value.to_sym)
  end

  def serialize(value)
    if value.present? && value.is_a?(RegistrationStep)
      super value.identifier
    else
      super
    end
  end
end
# :nocov:
