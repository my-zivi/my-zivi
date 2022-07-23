# frozen_string_literal: true

module CivilServants
  module CivilServantsHelper
    def regional_centers_collection
      RegionalCenter.all.to_h do |regional_center|
        [regional_center.name, regional_center.identifier]
      end
    end
  end
end
