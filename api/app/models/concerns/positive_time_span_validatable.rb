# frozen_string_literal: true

module Concerns
  module PositiveTimeSpanValidatable
    extend ActiveSupport::Concern

    included do
      validate :ending_is_after_beginning
    end

    private

    def ending_is_after_beginning
      return if ending.nil? || beginning.nil?

      errors.add(:ending, :before_beginning) unless ending >= beginning
    end
  end
end
