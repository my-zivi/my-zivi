# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Civil Servants Service Agreement Page', type: :system do
  let(:organization_one) { create(:organization, name: 'Org1') }
  let(:service_specification_organization_one) do
    create(:service_specification, organization: organization_one, name: 'Einsatz Feld')
  end
  let(:organization_two) { create(:organization, name: 'Org2') }

  let(:civil_servant) { create(:civil_servant, :full) }
  let(:service_agreement) do
    create(:service, :future, :civil_servant_agreement_pending,
           civil_servant: civil_servant, service_specification: service_specification_organization_one)
  end
  let(:service_definitive) { create(:service, :past, civil_servant: civil_servant) }

  before do
    sign_in civil_servant.user
    service_agreement
    service_definitive
    visit civil_servants_service_agreements_path
  end

  it 'can see his service agreements' do
    expect(page).to have_content I18n.l(service_agreement.beginning)
    expect(page).to have_content I18n.l(service_agreement.ending)
    expect(page).to have_content service_agreement.organization.name
    expect(page).to have_content service_agreement.service_specification.name

    expect(page).not_to have_content service_definitive.organization.name
    expect(page).not_to have_content service_definitive.service_specification.name
  end

  it 'can accept a service agreements' do
    expect { find('a.mr-3:nth-child(2)').click }.to(
      change { service_agreement.reload.civil_servant_decided_at }.from(nil)
        .and(
          change { service_agreement.reload.civil_servant_agreed }.from(nil).to(true)
        )
    )
  end

  it 'can decline a service agreements' do
    expect { find('a.mr-3:nth-child(1)').click }.to(
      change { service_agreement.reload.civil_servant_decided_at }.from(nil)
        .and(
          change { service_agreement.reload.civil_servant_agreed }.from(nil).to(false)
        )
    )
  end
end
