# frozen_string_literal: true

module Abilities
  class CivilServantAbility
    include CanCan::Ability

    def initialize(permitting_civil_servant)
      permitting_civil_servant_id = permitting_civil_servant.id

      can %i[read update], CivilServant, id: permitting_civil_servant_id
      can :read, Service, civil_servant_id: permitting_civil_servant_id
      can :read, :civil_servant_overview
      can :read, ExpenseSheet, service: { civil_servant_id: permitting_civil_servant_id }
    end
  end
end
