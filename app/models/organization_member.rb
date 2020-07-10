# frozen_string_literal: true

class OrganizationMember < ApplicationRecord
  belongs_to :organization
  has_one :user, as: :referencee, dependent: :destroy, required: false, autosave: true
  has_one :service_specification_contact_person,
          class_name: 'ServiceSpecification',
          inverse_of: :contact_person,
          dependent: :restrict_with_exception
  has_one :service_specification_lead_person,
          class_name: 'ServiceSpecification',
          inverse_of: :lead_person,
          dependent: :restrict_with_exception

  validates :first_name, :last_name, :phone, :organization_role, presence: true
  validates :contact_email, presence: true, if: -> { user.nil? }

  def full_name
    first_name + ' ' + last_name
  end

  def email
    contact_email || user.email
  end
end
