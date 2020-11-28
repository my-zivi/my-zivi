# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organizations::OverviewHelper do
  describe '#service_state_label' do
    subject(:label) { helper.service_state_label(service) }

    context 'when service confirmed and accepted' do
      let(:service) { build(:service, civil_servant_decided_at: 2.hours.ago) }

      it { is_expected.to eq I18n.t('service_states.active') }
    end

    context 'when service is waiting for approval of regional center' do
      let(:service) { build(:service, civil_servant_decided_at: 2.hours.ago, confirmation_date: nil) }

      it { is_expected.to eq I18n.t('service_states.pending_contract') }
    end

    context 'when civil servant agreement is pending' do
      let(:service) { build(:service, :civil_servant_agreement_pending) }

      it { is_expected.to eq I18n.t('service_states.waiting_for_civil_servant_decision') }
    end

    context 'when civil servant rejected' do
      let(:service) { build(:service, civil_servant_agreed: false, civil_servant_decided_at: 2.hours.ago) }

      it { is_expected.to eq I18n.t('service_states.civil_servant_rejected') }
    end
  end
end
