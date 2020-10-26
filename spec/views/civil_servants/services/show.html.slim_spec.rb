# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'civil_servants/services/show.html.slim', type: :view do
  let(:civil_servant) { create(:civil_servant, :full) }
  let(:user) { civil_servant.user }
  let(:service) { create(:service, :future, civil_servant: civil_servant) }
  let(:service_spec) { service.service_specification }
  let(:organization) { service.organization }
  let(:org_address) { organization.address }
  let!(:expense_sheet) do
    create(:expense_sheet, :locked,
           service: service, beginning: service.beginning, ending: service.ending)
  end

  let(:expected_strings) do
    [
      t('civil_servants.services.show.organization_information'),
      organization.name
    ] + [
      org_address.primary_line,
      org_address.secondary_line,
      org_address.supplement,
      org_address.street,
      org_address.zip_with_city
    ].compact + [
      t('civil_servants.services.show.schedule_information'),
      l(service.beginning),
      l(service.ending),
      service_spec.location,
      t('activerecord.enums.service.service_types.normal'),
      l(expense_sheet.beginning),
      l(expense_sheet.ending),
      expense_sheet.duration
    ]
  end

  before do
    sign_in user
    assign(:service, service)
    render
  end

  it 'displays all the information' do
    expect(rendered).to include(*expected_strings.map(&:to_s))
  end
end
