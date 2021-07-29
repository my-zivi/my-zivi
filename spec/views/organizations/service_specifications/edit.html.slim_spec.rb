# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organizations/service_specifications/edit', type: :view do
  let(:service_specification) { create(:service_specification) }
  let(:current_organization_admin) { build(:organization_member) }

  before do
    assign(:service_specification, service_specification)

    without_partial_double_verification do
      allow(view).to receive(:current_organization).and_return current_organization_admin.organization
      allow(view).to receive(:current_organization_admin).and_return current_organization_admin
    end
  end

  it_behaves_like 'renders service specification form' do
    let(:form_action) { organizations_service_specification_path(service_specification) }
  end
end
