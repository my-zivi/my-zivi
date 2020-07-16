# frozen_string_literal: true

class Organization < ApplicationRecord
  belongs_to :address, class_name: 'Address'
  belongs_to :letter_address, class_name: 'Address', optional: true
  belongs_to :creditor_detail

  has_many :organization_members, inverse_of: :organization, dependent: :destroy

  validates :name, :identification_number, presence: true
end
