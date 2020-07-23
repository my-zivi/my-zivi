# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organizations/service_specifications/new', type: :view do
  before do
    assign(:organizations_service_specification, Organizations::ServiceSpecification.new)
  end

  it 'renders new organizations_service_specification form' do
    render

    assert_select 'form[action=?][method=?]', organizations_service_specifications_path, 'post' do
    end
  end
end
