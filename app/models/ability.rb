# frozen_string_literal: true

class Ability
  include CanCan::Ability

  # :reek:FeatureEnvy
  def initialize(user)
    return if user.blank?

    referencee = user.referencee
    if referencee.is_a? CivilServant
      merge(Abilities::CivilServantAbility.new(referencee))
    elsif referencee.is_a? OrganizationMember
      merge(Abilities::OrganizationMemberAbility.new(referencee))
    end
  end
end
