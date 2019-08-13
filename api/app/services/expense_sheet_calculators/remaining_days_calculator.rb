# frozen_string_literal: true

module ExpenseSheetCalculators
  class RemainingDaysCalculator
    def initialize(service)
      @service = service
    end

    def remaining_days
      {
        sick_days: remaining_sick_days,
        paid_vacation_days: remaining_paid_vacation_days
      }
    end

    def remaining_sick_days
      eligible = @service.eligible_sick_days
      used = @service.used_sick_days
      eligible - used
    end

    def remaining_paid_vacation_days
      eligible = @service.eligible_paid_vacation_days
      used = @service.used_paid_vacation_days
      eligible - used
    end
  end
end
