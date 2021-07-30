# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength
module Abilities
  module Subscriptions
    class AdminAbility
      include CanCan::Ability

      def initialize(organization)
        organization_id = organization.id

        can(:access, :admin_subscription)
        can(:manage, OrganizationMember, organization_id: organization_id)
        can(:manage, ServiceSpecification, organization_id: organization_id)
        can(:manage, Payment, organization_id: organization_id)
        can(:manage, OrganizationHoliday, organization_id: organization_id)
        can(%i[read update], Organization, id: organization_id)
        can(:read, :phone_list)

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
        base_scope = { service_specification: { organization_id: organization_id } }

        can(:read, Service, base_scope)
        can(:crud, Service, base_scope.merge(
                              organization_agreed: true,
                              civil_servant_agreed: nil
                            ))

        can(:confirm, Service, base_scope.merge(
                                 organization_agreed: true,
                                 civil_servant_agreed: true,
                                 confirmation_date: nil
                               ))

        can(:destroy, Service, base_scope.merge(
                                 organization_agreed: true,
                                 civil_servant_agreed: false
                               ))
      end
    end
  end
end
# rubocop:enable Metrics/MethodLength
