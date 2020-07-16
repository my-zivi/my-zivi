# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.blank?

    if user.referencee.is_a? CivilServant
      merge(Abilities::CivilServantAbility.new(user.referencee))
    elsif user.referencee.is_a? OrganizationMember
      merge(Abilities::OrganizationMemberAbility.new(user.referencee))
    end
  end
end
