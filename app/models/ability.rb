# frozen_string_literal: true

class Ability
  include CanCan::Ability

  # :reek:FeatureEnvy
  def initialize(user)
    alias_action :create, :read, :update, :destroy, to: :crud

    can(:create, MailingList)
    can(:read, BlogEntry, published: true)
    can(:read, JobPosting, published: true)

    return if user.blank?

    if user.is_a?(SysAdmin)
      sys_admin_abilities(user)
    else
      user_abilities(user)
    end
  end

  private

  def user_abilities(user)
    referencee = user.referencee
    case referencee
    when CivilServant
      merge(Abilities::CivilServantAbility.new(referencee))
    when OrganizationMember
      merge(Abilities::OrganizationMemberAbility.new(referencee))
    end
  end

  def sys_admin_abilities(sys_admin)
    merge(Abilities::SysAdminAbility.new(sys_admin))
  end
end
