# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organizations::PaymentsHelper do
  describe '#payment_badge' do
    subject { helper.payment_badge(payment) }

    context 'when payment is open' do
      let(:payment) { build_stubbed(:payment) }

      it { is_expected.to include I18n.t('organizations.payments.badges.open.title') }
    end

    context 'when payment is paid' do
      let(:payment) { build_stubbed(:payment, :paid) }

      it { is_expected.to include I18n.t('organizations.payments.badges.paid.title') }
    end
  end
end
