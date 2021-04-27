# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authentication', type: :system do
  context 'when user is an organization administrator' do
    let(:organization_administrator) { create(:organization_member) }

    it 'can sign in' do
      visit new_user_session_path
      submit_sign_in_form(organization_administrator.user)
      expect(page).to have_current_path organizations_path
    end

    describe 'password change' do
      before { sign_in organization_administrator.user }

      it 'can change the password' do
        visit edit_organizations_member_path(organization_administrator)
        click_on I18n.t('organizations.organization_members.edit.change_password')
        expect(page).to have_content I18n.t('devise.registrations.edit.title')

        fill_in I18n.t('activerecord.attributes.user.current_password'), with: '12345678'
        fill_in I18n.t('activerecord.attributes.user.password'), with: 'S3CURP4SSW0RD##'
        fill_in I18n.t('activerecord.attributes.user.password_confirmation'), with: 'S3CURP4SSW0RD##'

        expect { click_on I18n.t('devise.registrations.edit.update') }.to(
          change { organization_administrator.reload.user.encrypted_password }
        )

        expect(page).to have_content(I18n.t('devise.registrations.updated')).and(have_current_path(organizations_path))
      end
    end
  end

  context 'when user is a civil servant' do
    let(:civil_servant) { create(:civil_servant, :full) }

    it 'can sign in' do
      visit new_user_session_path
      submit_sign_in_form(civil_servant.user)
      expect(page).to have_current_path civil_servants_path
    end

    describe 'password change' do
      before { sign_in civil_servant.user }

      it 'can change the password' do
        visit edit_civil_servants_civil_servant_path
        click_on I18n.t('civil_servants.civil_servants.edit.change_password')
        expect(page).to have_content I18n.t('devise.registrations.edit.title')

        fill_in I18n.t('activerecord.attributes.user.current_password'), with: '12345678'
        fill_in I18n.t('activerecord.attributes.user.password'), with: 'S3CURP4SSW0RD##'
        fill_in I18n.t('activerecord.attributes.user.password_confirmation'), with: 'S3CURP4SSW0RD##'

        expect { click_on I18n.t('devise.registrations.edit.update') }.to(
          change { civil_servant.reload.user.encrypted_password }
        )

        expect(page).to have_content(I18n.t('devise.registrations.updated')).and(have_current_path(civil_servants_path))
      end
    end
  end
end
