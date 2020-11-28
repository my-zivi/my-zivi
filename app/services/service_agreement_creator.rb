# frozen_string_literal: true

class ServiceAgreementCreator
  attr_reader :service_agreement, :civil_servant

  def initialize(civil_servant, organization_admin = nil)
    @organization_admin = organization_admin
    @civil_servant = civil_servant
    @service_agreement = nil
  end

  def call(service_agreement_params)
    ActiveRecord::Base.transaction do
      @service_agreement = Service.new(modify_organization_service_agreement_params(service_agreement_params))
      user = @service_agreement.civil_servant.user
      user.skip_password_validation!
      raise ActiveRecord::Rollback unless @service_agreement.valid?

      user.invite!(@organization_admin) if user.new_record?
      @service_agreement.save
    end
  end

  private

  def modify_organization_service_agreement_params(service_agreement_params)
    modified_params = service_agreement_params.merge(organization_agreed: true, civil_servant: @civil_servant)
    modified_params.delete(:civil_servant_attributes) if @civil_servant.persisted?
    modified_params
  end
end
