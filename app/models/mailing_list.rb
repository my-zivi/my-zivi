# frozen_string_literal: true

class MailingList < ApplicationRecord
  validates :organization, :name, :email, :telephone, presence: true
  validates :email, uniqueness: true
end
