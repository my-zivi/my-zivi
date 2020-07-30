# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organizations/service_specifications/index', type: :view do
  let(:organization_member) { create :organization_member }
  let(:service_specifications) do
    build_pair(:service_specification, id: 1, lead_person: organization_member, contact_person: organization_member)
  end

  before do
    assign(:service_specifications, service_specifications)
    render
  end

  it 'renders a list of service_specifications' do
    service_specifications.each do |service_specification|
      expect(rendered).to include service_specification.name
    end
  end
end
