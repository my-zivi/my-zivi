# frozen_string_literal: true

class CreditorDetail < ApplicationRecord
  has_one :organization, dependent: :restrict_with_exception

  validates :bic, :iban, presence: true
end
