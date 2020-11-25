# frozen_string_literal: true

module Abilities
  class CivilServantAbility
    include CanCan::Ability

    def initialize(permitting_civil_servant)
      permitting_civil_servant_id = permitting_civil_servant.id

      can :manage, CivilServant, id: permitting_civil_servant_id
      can :access, :registration_page
      return unless permitting_civil_servant.registered?

      cannot :access, :registration_page
      can :access, :civil_servant_portal
      can %i[read accept decline], Service, civil_servant_id: permitting_civil_servant_id
      can :read, :civil_servant_overview
      can :read, ExpenseSheet, service: { civil_servant_id: permitting_civil_servant_id }
    end
  end
end
