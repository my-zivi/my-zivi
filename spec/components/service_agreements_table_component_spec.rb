# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ServiceAgreementsTableComponent, type: :component do
  subject(:rendered) { render_inline(component) }

  let(:component) { described_class.new(service_agreements: [service_agreement]) }
  let(:civil_servant) { create(:civil_servant, :full, first_name: 'Elsbeth', last_name: 'Wayne') }
  let(:service_agreement) do
    build(:service,
          civil_servant: civil_servant,
          id: 1,
          beginning: '2020-01-06',
          ending: '2020-01-31',
          organization_agreed: '2020-01-01')
  end

  let(:rendered_column) { rendered.css('td').map(&:text).reject(&:empty?) }
  let(:rendered_header) { rendered.css('th').map(&:text).reject(&:empty?) }

  it 'renders a table of service agreements' do
    expect(rendered.to_s).to include(*described_class::COLUMNS.values.pluck(:label))
    expect(rendered.css('tr').length).to eq 2
    expect(rendered_column).to(
      contain_exactly('Elsbeth Wayne', '06.01.2020',
                      '31.01.2020', I18n.t('organizations.service_agreements.index.days.other', amount: 26))
    )
  end

  context 'when specifying custom columns' do
    let(:columns) { described_class::COLUMNS.slice(:duration) }
    let(:component) { described_class.new(service_agreements: [service_agreement], columns: columns) }

    it 'only renders the specified columns' do
      expect(rendered_column).to contain_exactly(
        I18n.t('organizations.service_agreements.index.days.other', amount: 26)
      )
      expect(rendered_header).to contain_exactly(described_class::COLUMNS[:duration][:label])
    end
  end
end
