# frozen_string_literal: true

class OrganizationMember < ApplicationRecord
  belongs_to :organization
  has_one :user, as: :referencee, dependent: :destroy, required: false, autosave: true

  validates :first_name, :last_name, :phone, :organization_role, presence: true
  validates :contact_email, presence: true, if: -> { user.nil? }

  accepts_nested_attributes_for :user

  def full_name
    first_name + ' ' + last_name
  end

  def email
    contact_email || user.email
  end
end
