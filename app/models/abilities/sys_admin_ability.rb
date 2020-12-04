# frozen_string_literal: true

module Abilities
  class SysAdminAbility
    include CanCan::Ability

    def initialize(_permitting_sys_admin)
      can(:access, :rails_admin)
      can(:read, :dashboard)

      operation_abilities
    end

    private

    def operation_abilities
      can(:manage, User)
      can(:manage, Organization)
      can(:manage, OrganizationMember)
      can(:manage, CivilServant)
      can(:manage, Service)
      can(:manage, ExpenseSheet)
      can(:manage, ServiceSpecification)
      can(:manage, Workshop)
      can(:manage, Address)
      can(:manage, CreditorDetail)
      can(:manage, Payment)
      can(:read, RegionalCenter)
    end
  end
end
