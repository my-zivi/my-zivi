# frozen_string_literal: true

require 'rails_helper'
require 'percy'

RSpec.describe 'Organizations Portal Screenshots', type: :system, js: true do
  let(:organization_administrator) { create(:organization_member) }

  before do
    sign_in organization_administrator.user
  end

  it 'renders front page correctly' do
    visit organizations_path
    Percy.snapshot(page, { name: 'Organizations Dashboard' })
  end
end
