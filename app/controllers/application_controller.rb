# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protected

  def after_sign_in_path_for(user)
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
