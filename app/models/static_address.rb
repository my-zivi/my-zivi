# frozen_string_literal: true

class StaticAddress < Address
  def readonly?
    true
  end
end
