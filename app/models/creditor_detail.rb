# frozen_string_literal: true

class CreditorDetail < ApplicationRecord
  include IbanValidatable

  has_one :organization, dependent: :nullify

  validates :bic, :iban, presence: true
  validates :bic, format: { with: /\A[A-Z]{6}[A-Z2-9][A-NP-Z0-9]([A-Z0-9]{3})?\z/ }
  validate :validate_iban
end
