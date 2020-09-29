# frozen_string_literal: true

class Organization < ApplicationRecord
  belongs_to :address, class_name: 'Address'
  belongs_to :letter_address, class_name: 'Address', optional: true
  belongs_to :creditor_detail

  has_many :organization_members, inverse_of: :organization, dependent: :destroy
  has_many :service_specifications, inverse_of: :organization, dependent: :restrict_with_exception
  has_many :services, through: :service_specifications
  has_many :expense_sheets, through: :services

  validates :name, :identification_number, presence: true
end
