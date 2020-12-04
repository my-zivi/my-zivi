# frozen_string_literal: true

module Abilities
  class SysAdminAbility
    include CanCan::Ability

    def initialize(permitting_civil_servant)
      can(:access, :rails_admin)
      can(:read, :dashboard)
      can(:manage, User)
      can(:manage, Organization)
      can(:manage, OrganizationMember)
    end
  end
end
