# frozen_string_literal: true

module OrganizationMembersHelper
  def initials(organization_member)
    (organization_member.first_name.first + organization_member.last_name.first).upcase
  end
end
