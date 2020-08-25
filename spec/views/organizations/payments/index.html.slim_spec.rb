# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organizations/payments/index.html.slim', type: :view do
  subject { rendered }

  let(:payments) do
    [
      build_stubbed(:payment, created_at: Date.parse('01-01-2020'), id: 1, amount: 12_000, state: 'paid'),
      build_stubbed(:payment, created_at: Date.parse('02-02-2020'), id: 2, amount: 2_300),
      build_stubbed(:payment, created_at: Date.parse('03-03-2020'), id: 3, amount: 4_500)
    ]
  end

  before do
    assign(:payments, payments)
    render
  end

  it 'renders a list of payments' do
    expect(rendered).to include '01.01.2020', organizations_payment_path(1), 'CHF 12\'000.00'
    expect(rendered).to include '02.02.2020', organizations_payment_path(2), 'CHF 2\'300.00'
    expect(rendered).to include '03.03.2020', organizations_payment_path(3), 'CHF 4\'500.00'
  end

  it 'contains the payment badges' do
    expect(rendered).to include I18n.t('organizations.payments.badges.paid.title')
    expect(rendered.scan(/#{I18n.t('organizations.payments.badges.open.title')}/).length).to(
      eq(2), 'There should be two open badges present'
    )
  end

  it 'contains all action menu links for open payments' do
    payments[1..].each do |payment|
      expect(rendered).to include organizations_payment_path(payment)
      expect(rendered).to include organizations_payment_path(payment, format: :xml)
      expect(rendered).to include organizations_payment_path(payment, payment: { state: 'paid' })
    end
  end

  it 'contains all action menu links for already paied payments' do
    expect(rendered).to include organizations_payment_path(payments.first)
    expect(rendered).to include organizations_payment_path(payments.first, format: :xml)
    expect(rendered).not_to include organizations_payment_path(payments.first, payment: { state: 'paid' })
  end
end
