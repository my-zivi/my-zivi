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

      expense_sheet_abilities(organization_id)
      service_abilities(organization_id)
    end

    private

    def expense_sheet_abilities(organization_id)
      can(:manage, ExpenseSheet, {
            service: {
              civil_servant_agreed: true,
              organization_agreed: true,
              service_specification: {
                organization_id: organization_id
              }
            }
          })

      cannot(:edit, ExpenseSheet, { state: 'locked' })
    end

    def service_abilities(organization_id)
      can(:read, Service, {
            civil_servant_agreed: true,
            organization_agreed: true,
            service_specification: {
              organization_id: organization_id
            }
          })

      can(:manage, Service, {
            civil_servant_agreed: false,
            organization_agreed: true,
            service_specification: {
              organization_id: organization_id
            }
          })
    end
    # rubocop:enable Metrics/MethodLength
  end
end
