# frozen_string_literal: true

module PortalHelper
  def current_portal
    case current_user.referencee
    when OrganizationMember
      :organization_portal
    when CivilServant
      :civil_servant_portal
    end
  end
end
