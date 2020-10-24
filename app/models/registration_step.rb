# frozen_string_literal: true

class RegistrationStep
  ALL = %i[personal address bank_and_insurance service_specific].freeze

  include ActiveModel::Model

  attr_accessor :identifier

  validates :identifier, presence: true, inclusion: { in: ALL }

  def next
    nth(1)
  end

  def previous
    nth(-1)
  end

  def nth(offset)
    new_index = index + offset
    return if new_index.negative?

    next_identifier = ALL[new_index]
    RegistrationStep.new(identifier: next_identifier) if next_identifier.present?
  end

  def last?
    identifier == ALL.last
  end

  alias complete? last?

  private

  def index
    ALL.index(identifier)
  end
end
