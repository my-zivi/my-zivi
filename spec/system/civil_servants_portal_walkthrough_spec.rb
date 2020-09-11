# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Civil Servants Portal Walkthrough', type: :system do
  let(:civil_servant) { create(:civil_servant, :full) }

  before do
    sign_in civil_servant.user
    visit civil_servants_path
  end

  it 'can navigate through portal' do
    expect(page).to have_content I18n.t('civil_servants.overview.index.titles.no_current_service')

    click_on I18n.t('base.civil_servants.navbar.services')
    expect(page).to have_content I18n.t('civil_servants.services.index.services')

    click_on I18n.t('base.civil_servants.navbar.profile')
    expect(page).to have_content civil_servant.full_name
  end
end
