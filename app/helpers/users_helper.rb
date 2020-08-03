# frozen_string_literal: true

module UsersHelper
  def current_organization_admin
    current_referencee.instance_of?(OrganizationMember) ? current_referencee : nil
  end

  def current_civil_servant
    current_referencee.instance_of?(CivilServant) ? current_referencee : nil
  end

  def current_organization
    current_organization_admin&.organization
  end

  private

  def current_referencee
    current_user&.referencee
  end
end
