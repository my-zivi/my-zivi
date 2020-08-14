# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organizations/civil_servants/show.html.erb', type: :view do
  subject { rendered }

  let(:civil_servant) { build(:civil_servant, **civil_servant_attributes) }
  let(:civil_servant_attributes) do
    {
      first_name: 'Zivi',
      last_name: 'Muster'
    }
  end

  before do
    assign(:civil_servant, civil_servant)
    render
  end

  it 'renders list of civil servants' do
    expect(rendered).to include(*civil_servant_attributes.values)
  end
end
