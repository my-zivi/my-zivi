# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organizations::OrganizationMembersHelper, type: :helper do
  describe '#initials' do
    subject { helper.initials(organization_member) }

    let(:organization_member) { build_stubbed(:organization_member, first_name: 'Peter', last_name: 'warlowsk') }

    it { is_expected.to eq 'PW' }
  end
end
