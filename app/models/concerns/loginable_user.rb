# frozen_string_literal: true

module LoginableUser
  extend ActiveSupport::Concern

  included do
    validates :language, presence: true
    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

    attribute :language, :string, default: 'german'

    enum language: {
      german: 'de-CH',
      french: 'fr-CH',
      italian: 'it-CH',
      english: 'en'
    }
  end

  def initialize(attributes)
    super(attributes)
    @validate_password = true
  end

  def skip_password_validation!
    @validate_password = false
  end

  def i18n_language
    lang = language_for_database&.to_sym
    lang.in?(I18n.available_locales) ? lang : I18n.default_locale
  end

  private

  def password_required?
    @validate_password
  end
end
