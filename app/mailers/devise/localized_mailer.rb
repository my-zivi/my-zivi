# frozen_string_literal: true

module Devise
  class LocalizedMailer < Devise::Mailer
    protected

    def devise_mail(record, action, opts = nil, &block)
      lang = record.try(:language_for_database)&.to_sym || :'de-CH'
      I18n.with_locale(lang) do
        super
      end
    end
  end
end
