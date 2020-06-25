# frozen_string_literal: true

class Organization < ApplicationRecord
  validates :name, presence: true

  belongs_to :address, class_name: 'Address'
  belongs_to :letter_address, class_name: 'Address', optional: true
  belongs_to :creditor_detail

  has_many :administrators, inverse_of: :organization, dependent: :destroy
end
