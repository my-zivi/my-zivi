# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe '#current_organization_admin' do
    subject(:current_organization_admin) { controller.current_organization_admin }

    before { allow(controller).to receive(:current_user).and_return current_user }

    context 'when an organization administrator is signed in' do
      let(:admin) { build(:organization_member) }

      let(:current_user) { admin.user }

      it { is_expected.to eq admin }
    end

    context 'when nobody is signed in' do
      let(:current_user) { nil }

      it { is_expected.to be_nil }
    end

    context 'when a civil servant is signed in instead' do
      let(:current_user) { build(:civil_servant, :full).user }

      it { is_expected.to be_nil }
    end
  end

  describe '#current_civil_servant' do
    subject(:current_civil_servant) { controller.current_civil_servant }

    before { allow(controller).to receive(:current_user).and_return current_user }

    context 'when a civil servant is signed in' do
      let(:civil_servant) { build(:civil_servant, :full) }
      let(:current_user) { civil_servant.user }

      it { is_expected.to eq civil_servant }
    end

    context 'when an organization administrator is signed in instead' do
      let(:current_user) { build(:organization_member).user }

      it { is_expected.to be_nil }
    end

    context 'when nobody is signed in' do
      let(:current_user) { nil }

      it { is_expected.to be_nil }
    end
  end

  describe '#current_organization' do
    subject { controller.current_organization }

    before { allow(controller).to receive(:current_user).and_return current_user }

    context 'when an organization administrator is signed in' do
      let(:organization) { create :organization, :with_admin }
      let(:admin) { build :organization_member, organization: organization }

      let(:current_user) { admin.user }

      it { is_expected.to eq organization }
    end

    context 'when nobody is signed in' do
      let(:current_user) { nil }

      it { is_expected.to be_nil }
    end

    context 'when a civil servant is signed in instead' do
      let(:current_user) { build(:civil_servant, :full).user }

      it { is_expected.to be_nil }
    end
  end
end
