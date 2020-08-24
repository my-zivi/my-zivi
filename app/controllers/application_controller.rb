# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protected

  def after_sign_in_path_for(user)
    case user.referencee
    when CivilServant
      civil_servants_path
    when OrganizationMember
      organizations_path
    end
  end
end
