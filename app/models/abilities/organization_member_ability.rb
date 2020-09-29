# frozen_string_literal: true

module Abilities
  class OrganizationMemberAbility
    include CanCan::Ability

    # rubocop:disable Metrics/MethodLength
    def initialize(permitting_organization_member)
      organization_id = permitting_organization_member.organization_id

      can :access, :organization_portal
      can :read, :organization_overview
      can %i[read update destroy], OrganizationMember, organization_id: organization_id
      can :manage, ServiceSpecification, organization_id: organization_id
      can :manage, Payment, organization_id: organization_id

      can(:read, CivilServant,
          services: {
            civil_servant_agreed: true,
            organization_agreed: true,
            service_specification: {
              organization_id: organization_id
            }
          })

      can(:manage, Service, {
            civil_servant_agreed: true,
            organization_agreed: true,
            service_specification: {
              organization_id: organization_id
            }
          })
      can(:manage, Service, {
            organization_agreed: true,
            service_specification: {
              organization_id: organization_id
            }
          })

      can(:manage, ExpenseSheet, {
            service: {
              civil_servant_agreed: true,
              organization_agreed: true,
              service_specification: {
                organization_id: organization_id
              }
            }
          })
    end

    # rubocop:enable Metrics/MethodLength
  end
end
