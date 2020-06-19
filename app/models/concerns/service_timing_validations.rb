# frozen_string_literal: true

module ServiceTimingValidations
  MIN_NORMAL_SERVICE_LENGTH = 26

  extend ActiveSupport::Concern

  included do
    validate :ending_is_friday, unless: :last_service?
    validate :beginning_is_monday
    validate :no_overlapping_service
    validate :length_is_valid
  end

  def no_overlapping_service
    errors.add(:beginning, :overlaps_service) if overlaps_other_service?
  end

  def overlaps_other_service?
    return false if civil_servant.nil?

    civil_servant.services.where.not(id: id).overlapping_date_range(beginning, ending).any?
  end

  def beginning_is_monday
    errors.add(:beginning, :not_a_monday) unless beginning.present? && beginning.monday?
  end

  def ending_is_friday
    errors.add(:ending, :not_a_friday) unless ending.present? && ending.friday?
  end

  def length_is_valid
    return if ending.blank? || beginning.blank? || last_service?

    errors.add(:service_days, :invalid_length) if (ending - beginning).to_i + 1 < MIN_NORMAL_SERVICE_LENGTH
  end
end
