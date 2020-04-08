# frozen_string_literal: true
module V1
  class CivilServantController < APIController




    private

    def civil_servant_params
      permitted_keys = ::Concerns::DeviseUserParamsRegistrable::PERMITTED_USER_KEYS + ADDITIONAL_PERMITTED_USER_PARAMS
      permitted_keys.push(ADMIN_RESTRICTED_USER_PARAMS) if current_user.admin?

      format_iban(params.require(:civil_servant).permit(*permitted_keys))
    end

    # :reek:UtilityFunction
    def format_iban(params)
      iban = params[:iban]
      params[:iban] = User.strip_iban(iban) if iban.present?
      params
    end
  end
end
