# frozen_string_literal: true

module Abilities
  class CivilServantAbility
    include CanCan::Ability

    def initialize(permitting_civil_servant)
      can :read, CivilServant, id: permitting_civil_servant.id
      can :read, :civil_servant_overview
    end
  end
end
