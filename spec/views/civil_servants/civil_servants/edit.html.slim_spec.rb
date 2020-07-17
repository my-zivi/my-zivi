# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'civil_servants/civil_servants/edit.html.erb', type: :view do
  before do
    sign_in user
    assign(:civil_servant, civil_servant)

    render
  end

  let(:civil_servant) { create(:civil_servant, :full) }
  let(:address) { civil_servant.address }
  let(:user) { civil_servant.user }

  let(:expected_strings) do
    [
      civil_servant.zdp,
      civil_servant.first_name,
      civil_servant.last_name,
      civil_servant.hometown,
      I18n.l(civil_servant.birthday),
      civil_servant.phone,
      civil_servant.iban,
      civil_servant.health_insurance,
      civil_servant.regional_center.name,
      address.primary_line,
      address.secondary_line,
      address.street,
      address.supplement,
      address.city,
      address.zip,
      user.email,
      I18n.t(user.language, scope: %i[activerecord attributes user languages]),
      civil_servant.workshops.pluck(:name).to_sentence,
      civil_servant.driving_licenses.pluck(:name).to_sentence,
      t('civil_servants.civil_servants.edit.cards.personal_information.title'),
      t('civil_servants.civil_servants.edit.cards.address_information.title'),
      t('civil_servants.civil_servants.edit.cards.login_information.title'),
      t('civil_servants.civil_servants.edit.cards.bank_and_insurance_information.title'),
      t('civil_servants.civil_servants.edit.cards.service_specific_information.title')
    ]
  end

  it 'displays all the information' do
    expected_strings.each do |value|
      expect(rendered).to include(value.to_s)
    end
  end
end
