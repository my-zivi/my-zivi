# frozen_string_literal: true

module Abilities
  class OrganizationMemberAbility
    include CanCan::Ability

    def initialize(organization_member)
      return if organization_member.member_privilege?

      organization = load_organization(organization_member) || organization_member.organization

      can(:access, :organization_portal)
      can(:read, :organization_overview)

      organization.subscriptions.each do |subscription|
        abilities_for_subscription(subscription, organization)
      end
    end

    private

    def load_organization(organization_member)
      Organization.includes(:subscriptions).find_by(id: organization_member.organization_id)
    end

    def abilities_for_subscription(subscription, organization)
      # noinspection RubyCaseWithoutElseBlockInspection
      case subscription
      when ::Subscriptions::Admin
        merge(Abilities::Subscriptions::AdminAbility.new(organization))
      when ::Subscriptions::Recruiting
        merge(Abilities::Subscriptions::RecruitingAbility.new(organization))
      end
    end
  end
end
