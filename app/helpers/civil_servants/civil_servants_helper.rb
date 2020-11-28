# frozen_string_literal: true

module CivilServants
  module CivilServantsHelper
    def regional_centers_collection
      RegionalCenter.all.map do |regional_center|
        [regional_center.name, regional_center.identifier]
      end.to_h
    end
  end
end
