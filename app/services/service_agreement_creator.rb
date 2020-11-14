# frozen_string_literal: true

class ServiceAgreementCreator
  class << self
    def call(service_agreement_params, service_creator)
      return unless service_creator.is_a? OrganizationMember

      create_org_service_agreement(service_agreement_params, service_creator)
    end

    private

    def create_org_service_agreement(service_agreement_params, current_organization_admin)
      ActiveRecord::Base.transaction do
        @service_agreement = Service.new(modify_service_agreement_params(service_agreement_params))
        user = @service_agreement.civil_servant.user
        user.skip_password_validation!
        raise ActiveRecord::Rollback unless @service_agreement.valid?

        user.invite!(current_organization_admin) if user.new_record?
        @service_agreement.save
      end
    end

    def modify_org_service_agreement_params(service_agreement_params)
      modified_params = service_agreement_params.merge(organization_agreed: true,
                                                       civil_servant: civil_servant(service_agreement_params))
      modified_params.delete(:civil_servant_attributes) if civil_servant.persisted?
      modified_params
    end

    def civil_servant(service_agreement_params)
      @civil_servant ||= find_civil_servant_by_email(service_agreement_params) || CivilServant.new(user: User.new)
    end

    def find_civil_servant_by_email(service_agreement_params)
      CivilServant.joins(:user).find_by(
        users: {
          email: service_agreement_params.dig(:civil_servant_attributes, :user_attributes, :email)
        }
      )
    end
  end
end
