# frozen_string_literal: true

class Ability
  include CanCan::Ability

  # :reek:FeatureEnvy
  def initialize(user)
    alias_action :create, :read, :update, :destroy, to: :crud

    can(:create, MailingList)
    can(:create, ServiceInquiry)
    can(:read, BlogEntry, published: true)
    can(:read, JobPosting, published: true)

    return if user.blank?

    user_abilities(user)
  end

  private

  def user_abilities(user)
    case user
    when SysAdmin
      merge(Abilities::SysAdminAbility.new(user))
    when CivilServant
      merge(Abilities::CivilServantAbility.new(user))
    when OrganizationMember
      merge(Abilities::OrganizationMemberAbility.new(user))
    end
  end
end
