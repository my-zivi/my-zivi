# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'civil_servants/services/index.html.slim', type: :view do
  let(:civil_servant) { create(:civil_servant, :full) }
  let(:user) { civil_servant.user }
  let(:services) do
    [
      create(:service, :active, civil_servant: civil_servant),
      create(:service, :future, civil_servant: civil_servant)
    ]
  end
  let(:filters) { { show_all: false } }

  let(:expected_strings) do
    expected_service_strings +
      [
        t('civil_servants.services.index.services'),
        t('civil_servants.services.index.show_past_services')
      ]
  end
  let(:expected_service_strings) do
    services.flat_map do |service|
      service_spec = service.service_specification
      [
        t('base.services.short_info_cell.service_with', org_name: service.organization.name),
        service_spec.name,
        service_spec.location,
        t('civil_servants.services.table_row.service_duration',
          beginning_date: l(service.beginning), ending_date: l(service.ending)),
        t(service.confirmation_date.present?,
          scope: %i[base services short_info_cell service_confirmed]),
        service.confirmation_date.nil? ? t('civil_servants.services.table_row.actions.download') : nil
      ]
    end
  end

  before do
    sign_in user
    assign(:services, services)
    assign(:filters, filters)
    render
  end

  it 'displays all the expected information' do
    expect(rendered).to include(*expected_strings.map(&:to_s))
  end
end
