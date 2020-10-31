# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'civil servant registration', type: :system, js: true do
  let!(:user) { User.invite!(referencee: build(:civil_servant), email: 'user@example.com', skip_invitation: true) }
  let(:civil_servant) { user.referencee }

  before do
    user.accept_invitation!
    sign_in user
    visit civil_servants_register_path
  end

  around do |spec|
    I18n.with_locale(:'de-CH') { spec.run }
  end

  it 'can invite the user', :without_bullet do
    complete_personal_step
    expect { click_next_button }.to(
      change { model_attributes(civil_servant, :zdp, :first_name, :last_name, :hometown, :birthday, :phone) }
    )

    complete_address_step
    expect { click_next_button }.to(
      change { model_attributes(civil_servant.reload.address, :primary_line, :secondary_line, :street, :city, :zip) }
    )

    complete_bank_and_insurance_step
    expect { click_next_button }.to(
      change { model_attributes(civil_servant, :iban, :health_insurance) }
    )

    complete_service_specific_step
    expect { click_complete_button }.to(
      change { model_attributes(civil_servant, :regional_center) }
    )
  end
end
