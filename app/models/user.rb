# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :referencee, polymorphic: true, autosave: true

  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable

  validates :language, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  enum language: {
    german: 'de',
    french: 'fr',
    italian: 'it',
    english: 'en'
  }

  def initialize(attributes)
    super(attributes)
    @validate_password = true
  end

  def skip_password_validation!
    @validate_password = false
  end

  private

  def password_required?
    @validate_password
  end
end
