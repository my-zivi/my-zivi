# frozen_string_literal: true

class Organization < ApplicationRecord
  belongs_to :address, class_name: 'Address'
  belongs_to :letter_address, class_name: 'Address', optional: true
  belongs_to :creditor_detail, optional: true

  has_many :organization_members, inverse_of: :organization, dependent: :destroy
  has_many :organization_holidays, inverse_of: :organization, dependent: :destroy
  has_many :service_specifications, inverse_of: :organization, dependent: :restrict_with_exception
  has_many :payments, inverse_of: :organization, dependent: :destroy
  has_many :job_postings, inverse_of: :organization, dependent: :nullify
  has_many :services, through: :service_specifications
  has_many :civil_servants, through: :services
  has_many :expense_sheets, through: :services
  has_many :subscriptions, dependent: :destroy, class_name: 'Subscriptions::Base'

  validates :name, :identification_number, presence: true

  has_one_attached :icon

  enum subscription: {
    admin: 'admin'
  }

  accepts_nested_attributes_for :address, allow_destroy: false, update_only: true
  accepts_nested_attributes_for :creditor_detail, allow_destroy: false, update_only: true, reject_if: :all_blank

  after_commit do
    job_postings.reindex! if job_postings.any?
  end

  def thumb_icon
    @thumb_icon ||= icon.variant(resize_to_limit: [60, 60]) if icon.attached?
  end

  # Checks if organization has SEPA PAIN (payment) generation enabled
  def pain_generation_enabled?
    creditor_detail.present?
  end
end
