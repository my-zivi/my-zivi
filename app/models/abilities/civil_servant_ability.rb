# frozen_string_literal: true

module Abilities
  class CivilServantAbility
    include CanCan::Ability

    def initialize(permitting_civil_servant)
      can %i[read update], CivilServant, id: permitting_civil_servant.id
      can :read, Service, civil_servant_id: permitting_civil_servant.id
      can :read, :civil_servant_overview
      can :read, ExpenseSheet, service: { civil_servant_id: permitting_civil_servant.id }
    end
  end
end
