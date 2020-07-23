# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organizations/service_specifications/index', type: :view do
  let(:service_specifications) { build_list(:service_specification, 2, id: 1) }

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
