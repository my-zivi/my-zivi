# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { described_class.new(user) }

  let(:user) { nil }

  it 'can create entries in mailing list but cannot access any portal' do
    expect(ability).to be_able_to(:create, MailingList)
    expect(ability).not_to be_able_to(:access, :civil_servant_portal)
    expect(ability).not_to be_able_to(:access, :organization_portal)
    expect(ability).not_to be_able_to(:access, :rails_admin)
  end

  context 'when the user is signed in as civil servant' do
    let(:civil_servant) { build(:civil_servant) }
    let(:user) { build(:user, referencee: civil_servant) }

    it 'cannot access organization portal or rails admin portal' do
      expect(ability).not_to be_able_to(:access, :organization_portal)
      expect(ability).not_to be_able_to(:access, :rails_admin)
    end

    context 'when civil servant has not completed registration yet' do
      it 'can only access the registration page and fill out profile' do
        expect(ability).to be_able_to(:access, :registration_page)
        expect(ability).not_to be_able_to(:access, :civil_servant_portal)
        expect(ability).to be_able_to(:manage, civil_servant)
      end
    end

    context 'when civil servant has completed registration' do
      let(:civil_servant) { build(:civil_servant, :service_specific_step_completed) }

      it 'can access the portal but cannot go back to registration step' do
        expect(ability).to be_able_to(:access, :civil_servant_portal)
        expect(ability).not_to be_able_to(:access, :registration_page)
        expect(ability).to be_able_to(:manage, civil_servant)
      end
    end
  end

  context 'when an organization member is signed in' do
    let(:organization) { build(:organization) }
    let(:organization_member) { build(:organization_member, organization: organization) }
    let(:user) { build(:user, referencee: organization_member) }

    it 'cannot access civil servants portal or rails admin portal' do
      expect(ability).not_to be_able_to(:access, :civil_servant_portal)
      expect(ability).not_to be_able_to(:access, :rails_admin)
    end

    describe 'expense sheets ability' do
      it { is_expected.not_to be_able_to(:edit, build(:expense_sheet, :locked)) }
    end
  end

  context 'when a sys admin is signed in' do
    let(:user) { build(:sys_admin) }

    it 'has access to rails admin but not to the portal' do
      expect(ability).to be_able_to(:access, :rails_admin)
      expect(ability).to be_able_to(:read, :dashboard)
      expect(ability).not_to be_able_to(:access, :civil_servant_portal)
      expect(ability).not_to be_able_to(:access, :organization_portal)
    end

    describe 'operator abilities' do
      it 'can manage all relevant models' do
        [
          User, Organization, OrganizationMember, CivilServant,
          Service, ExpenseSheet, ServiceSpecification, Workshop,
          Address, CreditorDetail, Payment, MailingList
        ].each { |klass| expect(ability).to be_able_to(:manage, klass) }
      end
    end
  end
end
