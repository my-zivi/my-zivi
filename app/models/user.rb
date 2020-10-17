# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :referencee, polymorphic: true

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
end
