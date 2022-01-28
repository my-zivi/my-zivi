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

  enum privilege: {
    member: 0,
    admin: 1
  }, _suffix: 'privilege'

  def full_name
    "#{first_name} #{last_name}"
  end

  protected

  def password_required?
    ability.can?(:access, :organization_portal)
  end

  def active_for_authentication?
    ability.can?(:access, :organization_portal)
  end

  private

  def ability
    @ability ||= Ability.new(self)
  end
end
