# frozen_string_literal: true

module Devise
  class LocalizedMailer < Devise::Mailer
    protected

    def devise_mail(record, action, opts = nil, &block)
      I18n.with_locale(record.try(:i18n_language) || I18n.default_locale) do
        super
      end
    end
  end
end
