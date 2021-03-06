# frozen_string_literal: true

class Service < ApplicationRecord
  include DateRangeFilterable
  include ServiceTimingValidations

  belongs_to :civil_servant
  belongs_to :service_specification

  has_many :expense_sheets, dependent: :restrict_with_error
  has_one :organization, through: :service_specification

  scope :chronologically, -> { order(beginning: :desc, ending: :desc) }
  scope :at_date, ->(date) { where(arel_table[:beginning].lteq(date)).where(arel_table[:ending].gteq(date)) }
  scope :at_year, ->(year) { overlapping_date_range(Date.new(year), Date.new(year).at_end_of_year) }
  scope :active, -> { where('beginning <= ?', Time.zone.now).where('ending >= ?', Time.zone.now) }
  scope :civil_servant_agreement_pending, -> { where(civil_servant_agreed: nil) }
  scope :organization_agreement_pending, -> { where(organization_agreed: nil) }
  scope :agreement, -> { civil_servant_agreement_pending.or(organization_agreement_pending) }
  scope :definitive, -> { where(organization_agreed: true, civil_servant_agreed: true) }

  enum service_type: {
    normal: 0,
    long: 1,
    probation: 2
  }, _suffix: 'civil_service'

  validates :ending, :beginning, presence: true
  validates :beginning, timeliness: true
  validates :ending, timeliness: { after: :beginning }
  validate :legitimate_civil_servant_decision
  validate :legitimate_organization_decision

  delegate :used_paid_vacation_days, :used_sick_days, to: :used_days_calculator
  delegate :remaining_paid_vacation_days, :remaining_sick_days, to: :remaining_days_calculator
  delegate :identification_number, to: :service_specification
  delegate :future?, to: :beginning
  delegate :past?, to: :ending

  accepts_nested_attributes_for :civil_servant

  before_destroy :check_definitive_service_destroy

  def service_days
    service_calculator.calculate_chargeable_service_days(ending)
  end

  def eligible_paid_vacation_days
    service_calculator.calculate_eligible_paid_vacation_days(service_days)
  end

  def eligible_sick_days
    service_calculator.calculate_eligible_sick_days(service_days)
  end

  def current?
    !future? && !past?
  end

  def date_range
    beginning..ending
  end

  def definitive?
    civil_servant_agreed? && organization_agreed?
  end

  def confirm!
    ExpenseSheet.transaction do
      update!(confirmation_date: Time.zone.today) && generate_expense_sheets!
      true
    end
  rescue StandardError => e
    Sentry.capture_exception(e, extra: { action: 'Service confirmation', service_id: id }) if defined? Sentry
    false
  end

  private

  def generate_expense_sheets!
    ExpenseSheetGenerator.new(self).create_expense_sheets!
  end

  def remaining_days_calculator
    @remaining_days_calculator ||= ExpenseSheetCalculators::RemainingDaysCalculator.new(self)
  end

  def used_days_calculator
    @used_days_calculator ||= ExpenseSheetCalculators::UsedDaysCalculator.new(self)
  end

  def service_calculator
    @service_calculator ||= ServiceCalculator.new(beginning, organization, {
                                                    last_service?: last_service?,
                                                    probation_civil_service?: probation_civil_service?
                                                  })
  end

  def check_definitive_service_destroy
    throw :abort if civil_servant_agreed && organization_agreed
  end

  def legitimate_civil_servant_decision
    return if civil_servant_decided_at.nil? || !civil_servant_agreed_changed?

    errors.add(:civil_servant_agreed, :already_decided)
  end

  def legitimate_organization_decision
    return if organization_decided_at.nil? || !organization_agreed_changed?

    errors.add(:organization_agreed, :already_decided)
  end
end
