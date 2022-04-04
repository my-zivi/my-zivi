# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Turbo::Redirection

  helper_method :current_organization_admin, :current_civil_servant, :current_organization, :current_referencee

  def current_organization_admin
    @current_organization_admin ||= current_referencee if current_referencee.instance_of?(OrganizationMember)
  end

  def current_civil_servant
    @current_civil_servant ||= current_referencee if current_referencee.instance_of?(CivilServant)
  end

  def current_organization
    @current_organization ||= current_organization_admin&.organization
  end

  def current_referencee
    @current_referencee ||= current_user&.referencee
  end

  protected

  def signed_in_root_path(user)
    return rails_admin_path if user.is_a? SysAdmin

    referencee = user.referencee

    case referencee
    when CivilServant
      after_civil_servant_sign_in(referencee)
    when OrganizationMember
      organizations_path
    end
  end

  private

  def after_civil_servant_sign_in(civil_servant)
    civil_servant.registered? ? civil_servants_path : civil_servants_register_path
  end
end
