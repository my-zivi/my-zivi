# frozen_string_literal: true

module Abilities
  class CivilServantAbility
    include CanCan::Ability

    def initialize(permitting_civil_servant)
      can :edit, CivilServant, id: permitting_civil_servant.id
      can :read, :civil_servant_overview
      can :read, :civil_servant_
    end
  end
end
