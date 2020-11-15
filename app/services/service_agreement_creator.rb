# frozen_string_literal: true

class ServiceAgreementCreator
  attr_reader :service_agreement, :civil_servant

  def initialize(organization_admin, params)
    @organization_admin = organization_admin
    @civil_servant = find_or_create_civil_servant civil_servant_email_from_params(params)
    @service_agreement = Service.new(civil_servant: @civil_servant)
  end

  def call(service_agreement_params)
    ActiveRecord::Base.transaction do
      @service_agreement.assign_attributes(modify_org_service_agreement_params(service_agreement_params))
      user = @service_agreement.civil_servant.user
      user.skip_password_validation!
      raise ActiveRecord::Rollback unless @service_agreement.valid?

      user.invite!(@organization_admin) if user.new_record?
      @service_agreement.save
    end
  end

  private

  def modify_org_service_agreement_params(service_agreement_params)
    @civil_servant = find_or_create_civil_servant(service_agreement_params)

    modified_params = service_agreement_params.merge(organization_agreed: true, civil_servant: @civil_servant)
    modified_params.delete(:civil_servant_attributes) if @civil_servant.persisted?
    modified_params
  end

  def civil_servant_email_from_params(params)
    params.dig(:civil_servant_attributes, :user_attributes, :email)
  end

  def find_or_create_civil_servant(email = nil)
    @civil_servant || find_civil_servant_by_email(email) || CivilServant.new(user: User.new)
  end

  def find_civil_servant_by_email(email)
    CivilServant.joins(:user).find_by(users: { email: email })
  end
end
