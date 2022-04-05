# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Organizations Member', type: :system, js: true do
  let(:organization_member) { create(:organization_member, :with_recruiting_subscribed_organization) }
  let(:created_organization_member) { OrganizationMember.order(:created_at).last }

  before { sign_in organization_member.user }

  it 'can add and update an organization member' do
    visit organizations_members_path
    click_on I18n.t('organizations.organization_members.index.new_organization_member')
    fill_in I18n.t('activerecord.attributes.organization_member.first_name'), with: 'John'
    fill_in I18n.t('activerecord.attributes.organization_member.last_name'), with: 'Doe'
    fill_in I18n.t('activerecord.attributes.user.email'), with: 'john@example.com'
    fill_in I18n.t('activerecord.attributes.organization_member.phone'), with: '+1 555 555 5555'
    fill_in I18n.t('activerecord.attributes.organization_member.organization_role'), with: 'Member'
    expect do
      click_on I18n.t('helpers.submit.create', model: I18n.t('activerecord.models.organization_member'))
      expect(page).to have_content(I18n.t('organizations.organization_members.create.successfully_created'))
    end.to(change(OrganizationMember, :count).by(1))

    click_on 'John Doe'
    expect(page).to have_content(I18n.t('organizations.organization_members.edit.subtitle'))
    fill_in I18n.t('activerecord.attributes.organization_member.first_name'), with: 'Joooohn'

    expect do
      click_on I18n.t('helpers.submit.update', model: I18n.t('activerecord.models.organization_member'))
      expect(page).to have_content(I18n.t('organizations.organization_members.update.successfully_updated'))
    end.to(change { created_organization_member.reload.first_name }.from('John').to('Joooohn'))
  end
end
