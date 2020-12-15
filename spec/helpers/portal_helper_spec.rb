# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PortalHelper, type: :helper do
  describe '#current_portal' do
    subject { helper.current_portal }

    let(:user) { build_stubbed(:user, referencee: referencee) }

    before { allow(helper).to receive(:current_user).and_return user }

    context 'when an organization member is signed in' do
      let(:referencee) { build(:organization_member, :without_login) }

      it { is_expected.to eq :organization_portal }
    end

    context 'when a civil servant is signed in' do
      let(:referencee) { build(:civil_servant) }

      it { is_expected.to eq :civil_servant_portal }
    end

    context 'when the user is invalid' do
      let(:referencee) { nil }

      it { is_expected.to be_nil }
    end
  end
end
