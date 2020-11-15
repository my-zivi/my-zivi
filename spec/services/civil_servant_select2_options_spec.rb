# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CivilServantSelect2Options, type: :service do
  subject(:select2_options) { described_class.call(all_civil_servants, organization_civil_servants) }

  let(:all_civil_servants) { CivilServant.all }
  let(:organization_civil_servants) { CivilServant.limit(1) }

  let(:first_civil_servant) { CivilServant.first }
  let(:second_civil_servant) { CivilServant.second }

  before do
    create_list(:civil_servant, 2, :full)
  end

  # rubocop:disable RSpec/ExampleLength
  it 'returns the data in select2 format' do
    expect(select2_options).to eq(
      [
        {
          children: [
            {
              id: first_civil_servant.user.email,
              text: "#{first_civil_servant.full_name}, #{first_civil_servant.user.email}"
            },
            {
              id: second_civil_servant.user.email,
              text: "#{second_civil_servant.full_name}, #{second_civil_servant.user.email}"
            }
          ],
          text: I18n.t('organizations.service_agreements.search.modal.dropdown.groups.recent_civil_servants')
        },
        {
          children: [
            {
              id: first_civil_servant.user.email,
              text: "#{first_civil_servant.full_name}, #{first_civil_servant.user.email}"
            },
            {
              id: second_civil_servant.user.email,
              text: "#{second_civil_servant.full_name}, #{second_civil_servant.user.email}"
            }
          ],
          text: I18n.t('organizations.service_agreements.search.modal.dropdown.groups.all_civil_servants')
        },
        {
          children: [
            {
              id: -1,
              text: I18n.t('organizations.service_agreements.search.modal.dropdown.groups.new_civil_servant')
            }
          ],
          text: I18n.t('organizations.service_agreements.search.modal.dropdown.groups.new_civil_servant')
        }
      ]
    )
  end
  # rubocop:enable RSpec/ExampleLength
end
