# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Abilities::OrganizationMemberAbility do
  subject { described_class.new(organization_member) }

  let(:organization) { create(:organization) }
  let(:organization_member) { create(:organization_member, organization: organization) }

  describe 'expense sheets ability' do
    it { is_expected.not_to be_able_to(:edit, build(:expense_sheet, :locked)) }
  end
end
