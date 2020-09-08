# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organizations/services/index.html.slim', type: :view do
  before { render }

  it 'has preact container' do
    expect(rendered).to include 'id="planning-app"'
  end
end
