# frozen_string_literal: true

def get_service_range(months:)
  beginning = Date.parse('2018-01-01')
  ending = beginning + 25.days + (months - 1) * 28.days
  beginning..ending
end
