# frozen_string_literal: true

# :nocov:
class RegionalCenterColumn < ActiveModel::Type::ImmutableString
  def cast(value)
    return nil if value.blank?
    return value if value.is_a?(RegionalCenter)

    RegionalCenter.find(value)
  end

  def serialize(value)
    if value.present? && value.is_a?(RegionalCenter)
      super value.identifier
    else
      super
    end
  end
end
# :nocov:
