# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'civil servant registration', :without_bullet, type: :system do
  let!(:user) { User.invite!(referencee: build(:civil_servant), email: 'user@example.com', skip_invitation: true) }
  let(:civil_servant) { user.referencee }

  let(:personal_step_attributes) { %i[zdp first_name last_name hometown birthday phone] }
  let(:address_step_attributes) { %i[primary_line secondary_line street city zip] }

  before do
    user.accept_invitation!
    sign_in user
    visit civil_servants_register_path
  end

  around do |spec|
    I18n.with_locale(:'de-CH') { spec.run }
  end

  it 'can fill out registration form' do
    complete_personal_step
    expect { click_next_button }.to(
      change { model_attributes(civil_servant, :registration_step, *personal_step_attributes) }
    )

    complete_address_step
    expect { click_next_button }.to(
      change { model_attributes(civil_servant.reload.address, :registration_step, *address_step_attributes) }
    )

    complete_bank_and_insurance_step
    expect { click_next_button }.to(
      change { model_attributes(civil_servant, :iban, :health_insurance) }
    )

    complete_service_specific_step
    expect { click_complete_button }.to(
      change { model_attributes(civil_servant, :regional_center) }
    )

    expect(page.body).to include I18n.t('successful_registration')
  end

  it 'when a step has errors it does not allow to proceed' do
    complete_personal_step(first_name: '')
    expect { click_next_button }.not_to(change(civil_servant, :reload))
    expect(page.body).to include I18n.t('civil_servants.registrations.update.erroneous_update')

    visit civil_servants_register_path(displayed_step: 'bank_and_insurance')
    expect(page.body).not_to include I18n.t('activerecord.attributes.civil_servant.iban')
    expect(find('[name="civil_servant[registration_step]"]', visible: false).value).to eq 'personal'
  end
end
