# frozen_string_literal: true

class RegistrationStep
  ALL = %i[personal address bank_and_insurance service_specific].freeze

  include ActiveModel::Model
  include Comparable

  attr_accessor :identifier

  validates :identifier, presence: true, inclusion: { in: ALL }

  ALL.each do |identifier|
    define_method :"#{identifier}_step_completed?" do
      ALL.index(identifier) <= index
    end
  end

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

  def first?
    identifier == ALL.first
  end

  def <=>(other)
    index <=> other.index if other.present?
  end

  alias complete? last?

  def index
    ALL.index(identifier)
  end
end
