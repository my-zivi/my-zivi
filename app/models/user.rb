# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :referencee, polymorphic: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
