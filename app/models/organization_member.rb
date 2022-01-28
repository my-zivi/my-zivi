# frozen_string_literal: true

class OrganizationMember < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  include LoginableUser
  include DeviseInvitable::Inviter

  belongs_to :organization
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

  validates :first_name, :last_name, :phone, :organization_role, :email, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end
end
