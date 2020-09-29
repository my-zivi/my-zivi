# frozen_string_literal: true

def submit_sign_in_form(user)
  fill_in I18n.t('activerecord.attributes.user.email'), with: user.email
  fill_in I18n.t('activerecord.attributes.user.password'), with: user.password
  click_button I18n.t('devise.sessions.new.sign_in')
end
