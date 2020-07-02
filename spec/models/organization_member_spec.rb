# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganizationMember, type: :model do
  describe 'model definition' do
    subject(:model) { described_class.new }

    it 'defines relations' do
      expect(model).to belong_to(:organization)
      expect(model).to have_one(:user).dependent(:destroy).required(false)
    end
  end

  describe 'validation' do
    it_behaves_like 'validates presence of required fields', %i[
      first_name
      last_name
      phone
      organization_role
    ]

    context 'when there is a user' do
      subject { build :organization_member, :with_user }

      it { is_expected.not_to validate_presence_of :contact_email }
    end

    context 'when there is no user' do
      subject { build :organization_member, :with_contact_email }

      it { is_expected.to validate_presence_of :contact_email }
    end
  end

  describe '#email' do
    subject { organization_member.email }

    context 'when there is a user' do
      let(:organization_member) { build :organization_member, :with_user }

      it { is_expected.to eq organization_member.user.email }
    end

    context 'when there is no user' do
      let(:organization_member) { build :organization_member, :with_contact_email }

      it { is_expected.to eq organization_member.contact_email }
    end
  end
end
