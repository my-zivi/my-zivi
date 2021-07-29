# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organizations/payments/show.html.slim', type: :view do
  subject { rendered }

  let(:civil_servant) { create(:civil_servant, :full, :with_service) }

  let(:payment) do
    build(:payment,
          id: 1,
          created_at: '2020-04-01',
          amount: 12,
          expense_sheets: build_pair(:expense_sheet, id: 2, service: civil_servant.services.first))
  end

  before do
    assign(:payment, payment)
    without_partial_double_verification do
      allow(view).to receive(:current_organization).and_return build(:organization)
    end

    render
  end

  it 'does render' do
    expect(rendered).to include I18n.t('organizations.payments.show.title', date: '01.04.2020'), 'CHF 12.00'
    expect(rendered).to include I18n.t('organizations.payments.show.expense_sheets_table.title')
    expect(rendered.scan(/Zivi Mustermann/).length).to eq 2
  end
end
