# frozen_string_literal: true

module Abilities
  module Subscriptions
    class RecruitingAbility
      include CanCan::Ability

      def initialize(organization)
        organization_id = organization.id

        can(:access, :recruiting_subscription)
        can(:manage, JobPosting, organization_id: organization_id)
        can(%i[read update], Organization, id: organization_id)
        can(:manage, OrganizationMember, organization_id: organization_id)
      end
    end
  end
end
