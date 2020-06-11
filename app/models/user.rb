# frozen_string_literal: true

class User < ApplicationRecord
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  belongs_to :referencee, polymorphic: true
end
