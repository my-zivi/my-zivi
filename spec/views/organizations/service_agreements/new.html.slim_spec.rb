# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organizations/service_agreements/new.html.slim', type: :view do
  let(:civil_servant) { CivilServant.new(user: User.new) }
  let(:expected_form_labels) do
    [
      t('activerecord.attributes.civil_servant.first_name'),
      t('activerecord.attributes.civil_servant.last_name'),
      t('activerecord.attributes.civil_servant.email'),
      t('activerecord.attributes.service.beginning'),
      t('activerecord.attributes.service.ending'),
      t('activerecord.attributes.service.service_days'),
      t('activerecord.attributes.service.service_type'),
      t('activerecord.attributes.service.service_specification'),
      t('activerecord.attributes.service.last_service'),
      t('activerecord.enums.service.service_types.normal')
    ]
  end
  let(:service_agreement) { build(:service, civil_servant: civil_servant, organization: create(:organization)) }
  let(:organization) { create(:organization) }

  before do
    assign(:service_agreement, service_agreement)
    assign(:service_specifications, organization.service_specifications)
    render
  end

  context 'when civil servant is not set' do
    let(:expected_strings) do
      expected_form_labels + [
        l(service_agreement.beginning),
        l(service_agreement.ending),
        service_agreement.service_days
      ]
    end

    it 'displays all the information' do
      expect(rendered).to include(*expected_strings.map(&:to_s))
    end
  end

  context 'when civil servant is set' do
    let(:civil_servant) { create(:civil_servant, :full) }
    let(:expected_strings) do
      expected_form_labels + [
        civil_servant.first_name,
        civil_servant.last_name,
        l(service_agreement.beginning),
        l(service_agreement.ending),
        service_agreement.service_days
      ]
    end

    it 'displays all the information' do
      expect(rendered).to include(*expected_strings.map(&:to_s))
    end
  end
end
