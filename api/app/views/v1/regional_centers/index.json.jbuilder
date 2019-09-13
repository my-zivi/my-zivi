# frozen_string_literal: true

json.array! @regional_centers do |regional_center|
  json.extract! regional_center, :name, :address, :short_name, :id
end
