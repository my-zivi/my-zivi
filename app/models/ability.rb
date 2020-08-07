# frozen_string_literal: true

class Ability
  include CanCan::Ability

  # :reek:FeatureEnvy
  def initialize(user)
    can :create, MailingList

    return if user.blank?

    referencee = user.referencee
    case referencee
    when CivilServant
      merge(Abilities::CivilServantAbility.new(referencee))
    when OrganizationMember
      merge(Abilities::OrganizationMemberAbility.new(referencee))
    end
  end
end
