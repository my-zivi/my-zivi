# frozen_string_literal: true

module Abilities
  class SysAdminAbility
    include CanCan::Ability

    def initialize(_permitting_sys_admin)
      can(:access, :rails_admin)
      can(:read, :dashboard)

      operation_abilities
    end

    private

    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    def operation_abilities
      can(:manage, User)
      can(:manage, Organization)
      can(:manage, OrganizationMember)
      can(:manage, CivilServant)
      can(:manage, Service)
      can(:manage, ExpenseSheet)
      can(:manage, ServiceSpecification)
      can(:manage, Workshop)
      can(:manage, Address)
      can(:manage, CreditorDetail)
      can(:manage, Payment)
      can(:manage, MailingList)
      can(:manage, BlogEntry)
      can(:manage, JobPosting)
      can(:manage, Faq)
      can(:read, RegionalCenter)
      can(:read, JobPostingApi::PollLog)
      can(:read, ServiceInquiry)
    end
    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
  end
end
