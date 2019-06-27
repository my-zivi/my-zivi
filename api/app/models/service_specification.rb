# frozen_string_literal: true

class ServiceSpecification < ApplicationRecord
  ALLOWED_EXPENSE_KEYS = %w[breakfast lunch dinner].freeze

  serialize :work_days_expenses, JSON
  serialize :paid_vacation_expenses, JSON
  serialize :first_day_expenses, JSON
  serialize :last_day_expenses, JSON

  enum location: {
    valais: 'vs',
    zurich: 'zh'
  }, _prefix: true

  has_many :services, dependent: :restrict_with_error

  validates :accommodation_expenses, :first_day_expenses,
            :identification_number, :last_day_expenses,
            :location, :name, :paid_vacation_expenses,
            :work_clothing_expenses, :work_days_expenses,
            :short_name, presence: true

  validates :accommodation_expenses, :work_clothing_expenses, numericality: { only_integer: true }
  validates :identification_number, length: { minimum: 5, maximum: 7 }

  validate :validate_work_days_expenses
  validate :validate_paid_vacation_expenses
  validate :validate_first_day_expenses
  validate :validate_last_day_expenses

  def title
    "#{identification_number} #{name}"
  end

  private

  def validate_work_days_expenses
    validate_json_format(:work_days_expenses)
    validate_numericality_of_json(:work_days_expenses)
  end

  def validate_paid_vacation_expenses
    validate_json_format(:paid_vacation_expenses)
    validate_numericality_of_json(:paid_vacation_expenses)
  end

  def validate_first_day_expenses
    validate_json_format(:first_day_expenses)
    validate_numericality_of_json(:first_day_expenses)
  end

  def validate_last_day_expenses
    validate_json_format(:last_day_expenses)
    validate_numericality_of_json(:last_day_expenses)
  end

  def validate_json_format(attribute)
    return if self[attribute].nil?

    keys = self[attribute].keys

    contains_only_valid_keys = keys.all? { |key| ALLOWED_EXPENSE_KEYS.include? key }
    has_same_length = keys.length == ALLOWED_EXPENSE_KEYS.length

    errors.add(attribute, :wrong_keys) unless has_same_length && contains_only_valid_keys
  end

  def validate_numericality_of_json(attribute)
    return if self[attribute].nil?

    errors.add(attribute, :not_an_unsigned_integer) unless values_numeric?(self[attribute].values)
  end

  # :reek:UtilityFunction
  def values_numeric?(values)
    values.all? { |value| value.is_a?(Integer) && !value.negative? }
  end
end
