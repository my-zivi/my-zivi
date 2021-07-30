# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organizations/organizations/edit.html.slim', type: :view do
  let(:organization) { create(:organization, :with_admin) }
  let(:organization_member) { create(:organization_member, organization: organization) }

  before do
    assign(:organization, organization)
    sign_in organization_member.user
    render
  end

  it 'renders title of organization and organization related fields' do
    expect(rendered).to include organization.name
    expect(rendered).to have_input_field('organization[name]').with_value(organization.name)
    expect(rendered).to(
      have_input_field('organization[identification_number]').with_value(organization.identification_number)
    )
  end

  describe 'address fields' do
    let(:expected_fields) do
      {
        'primary_line' => organization.address.primary_line,
        'secondary_line' => nil,
        'supplement' => nil,
        'street' => organization.address.street,
        'zip' => organization.address.zip
      }
    end

    it 'contains all address related fields' do
      expected_fields.each do |expected_field, expected_value|
        expect(rendered).to(
          have_input_field("organization[address_attributes][#{expected_field}]").with_value(expected_value)
        )
      end
    end
  end

  describe 'creditor details' do
    it 'contains all creditor detail related fields' do
      expect(rendered).to(
        have_input_field('organization[creditor_detail_attributes][iban]').with_value(organization.creditor_detail.iban)
      )

      expect(rendered).to(
        have_input_field('organization[creditor_detail_attributes][bic]').with_value(organization.creditor_detail.bic)
      )
    end

    context 'when organization does not have admin subscription' do
      let(:organization) { create(:organization, :with_recruiting) }

      it 'does not contain creditor detail related fields' do
        expect(rendered).not_to(have_input_field('organization[creditor_detail_attributes][iban]'))
        expect(rendered).not_to(have_input_field('organization[creditor_detail_attributes][bic]'))
      end
    end
  end
end
