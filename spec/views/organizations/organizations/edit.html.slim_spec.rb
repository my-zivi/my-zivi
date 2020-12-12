# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organizations/organizations/edit.html.slim', type: :view do
  let(:organization) { create(:organization) }

  before do
    assign(:organization, organization)
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
    it 'contains all address related fields' do
      expect(rendered).to have_input_field('address[primary_line]').with_value(organization.address.primary_line)
      expect(rendered).to have_input_field('address[secondary_line]')
      expect(rendered).to have_input_field('address[supplement]')
      expect(rendered).to have_input_field('address[street]').with_value(organization.address.street)
      expect(rendered).to have_input_field('address[zip]').with_value(organization.address.zip)
    end
  end

  describe 'creditor details' do
    it 'contains all creditor detail related fields' do
      expect(rendered).to have_input_field('creditor_detail[iban]').with_value(organization.creditor_detail.iban)
      expect(rendered).to have_input_field('creditor_detail[bic]').with_value(organization.creditor_detail.bic)
    end
  end
end
