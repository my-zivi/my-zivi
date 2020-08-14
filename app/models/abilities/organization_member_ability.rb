# frozen_string_literal: true

module Abilities
  class OrganizationMemberAbility
    include CanCan::Ability

    def initialize(permitting_organization_member)
      can %i[read update destroy], OrganizationMember, organization_id: permitting_organization_member.organization_id
      can :read, :organization_overview
      can :manage, ServiceSpecification, organization_id: permitting_organization_member.organization_id
      can(:read, CivilServant,
          services: {
            service_specification: {
              organization_id: permitting_organization_member.organization_id
            }
          })
    end
  end
end
