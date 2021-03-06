# frozen_string_literal: true

class OrganizationMember < ApplicationRecord
  include DeviseInvitable::Inviter

  belongs_to :organization
  has_one :user, as: :referencee, dependent: :destroy, required: false, autosave: true
  has_many :service_specification_contacts,
           class_name: 'ServiceSpecification',
           inverse_of: :contact_person,
           dependent: :restrict_with_exception,
           foreign_key: :contact_person_id
  has_many :service_specification_leads,
           class_name: 'ServiceSpecification',
           inverse_of: :lead_person,
           dependent: :restrict_with_exception,
           foreign_key: :contact_person_id

  validates :first_name, :last_name, :phone, :organization_role, presence: true
  validates :contact_email, presence: true, if: -> { user.nil? }

  accepts_nested_attributes_for :user

  def full_name
    "#{first_name} #{last_name}"
  end

  def email
    contact_email || user.email
  end
end
