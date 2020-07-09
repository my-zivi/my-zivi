# frozen_string_literal: true

module ApplicationHelper
  def current_organization_admin
    current_referencee.instance_of?(Administrator) ? current_referencee : nil
  end

  def current_civil_servant
    current_referencee.instance_of?(CivilServant) ? current_referencee : nil
  end

  private

  def current_referencee
    current_user&.referencee
  end
end
