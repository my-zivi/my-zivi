# frozen_string_literal: true

class OrganizationMember < ApplicationRecord
  belongs_to :organization
  has_one :user, as: :referencee, dependent: :destroy

  validates :first_name, :last_name, :phone, :organization_role, presence: true
  validates :contact_email, presence: true, if: -> { user.nil? }
end
