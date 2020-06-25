class CreditorDetail < ApplicationRecord
  has_one :organization

  validates :bic, :iban, presence: true
end
