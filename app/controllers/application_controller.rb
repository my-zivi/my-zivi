# frozen_string_literal: true

class ApplicationController < ActionController::Base
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
