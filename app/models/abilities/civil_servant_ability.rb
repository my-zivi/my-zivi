# frozen_string_literal: true

module Abilities
  class CivilServantAbility
    include CanCan::Ability

    def initialize(civil_servant)
      permit! civil_servant
    end

    def permit!(permitting_civil_servant)
      can :read, CivilServant, id: permitting_civil_servant.id
    end
  end
end
