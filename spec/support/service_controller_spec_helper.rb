# frozen_string_literal: true

def complement_service(service, specification_params:, organization_params:)
  organization = create(:organization, :with_admin, **organization_params)

  service.service_specification = create(:service_specification, organization: organization, **specification_params)
  service.save
  service
end
