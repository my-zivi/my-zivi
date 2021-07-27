# frozen_string_literal: true

module Abilities
  module Subscriptions
    class RecruitingAbility
      include CanCan::Ability

      def initialize(organization)
        can(:access, :recruiting_subscription)
        can(:manage, JobPosting, organization_id: organization.id)
        can(%i[read update], Organization, id: organization.id)
      end
    end
  end
end
