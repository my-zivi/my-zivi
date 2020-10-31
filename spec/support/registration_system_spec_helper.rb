# frozen_string_literal: true

def complete_personal_step(**overrides)
  fill_in 'civil_servant[zdp]', with: overrides[:zdp] || '10001'
  fill_in 'civil_servant[first_name]', with: overrides[:first_name] || 'Harry'
  fill_in 'civil_servant[last_name]', with: overrides[:last_name] || 'Potter'
  fill_in 'civil_servant[hometown]', with: overrides[:hometown] || 'Hogwarts'
  select '1', from: 'civil_servant[birthday(3i)]'
  select 'Januar', from: 'civil_servant[birthday(2i)]'
  select 5.years.ago.year.to_s, from: 'civil_servant[birthday(1i)]'
  fill_in 'civil_servant[phone]', with: overrides[:phone] || '044 123 45 45'
end

def complete_address_step
  fill_in 'civil_servant[address_attributes][primary_line]', with: 'Harry Potter'
  fill_in 'civil_servant[address_attributes][secondary_line]', with: 'Second Floor'
  fill_in 'civil_servant[address_attributes][street]', with: 'Downstreet 12'
  fill_in 'civil_servant[address_attributes][city]', with: 'London'
  fill_in 'civil_servant[address_attributes][zip]', with: '1234'
end

def complete_bank_and_insurance_step
  fill_in 'civil_servant[iban]', with: 'CH9300762011623852957'
  fill_in 'civil_servant[health_insurance]', with: 'Sanicare'
end

def complete_service_specific_step
  select RegionalCenter.rueti.name, from: 'civil_servant[regional_center]'
end

def click_next_button
  click_button I18n.t('actions.next')
end

def click_complete_button
  click_button I18n.t('actions.complete')
end

def model_attributes(model, *attributes)
  return {} unless model

  model.reload.attributes.with_indifferent_access.slice(*attributes)
end
