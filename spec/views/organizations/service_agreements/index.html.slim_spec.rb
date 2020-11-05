# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organizations/service_agreements/index.html.slim', type: :view do
  let(:expected_form_labels) do
    [
      t('activerecord.models.civil_servant'),
      t('activerecord.attributes.service.beginning'),
      t('activerecord.attributes.service.ending'),
      t('activerecord.attributes.service.service_days')
    ]
  end
  let(:expected_strings) do
    expected_form_labels + service_agreements.map do |service_agreement|
      [
        l(service_agreement.beginning),
        l(service_agreement.ending),
        service_agreement.service_days
      ]
    end.flatten
  end
  let(:first_civil_servant) { create :civil_servant, :full, first_name: 'Hans', last_name: 'Hugentobler' }
  let(:second_civil_servant) { create :civil_servant, :full, first_name: 'Martilda', last_name: 'Schenkel' }
  let(:third_civil_servant) { create :civil_servant, :full, first_name: 'Peter', last_name: 'Lustig' }
  let(:service_agreements) do
    [
      create(:service, civil_servant: first_civil_servant),
      create(:service, civil_servant: second_civil_servant),
      create(:service, civil_servant: third_civil_servant)
    ]
  end
  let(:organization) { create :organization }

  before do
    assign(:service_agreements, service_agreements)
    render
  end

  it 'displays all the information' do
    expect(rendered).to include(*expected_strings.map(&:to_s))
  end
end
