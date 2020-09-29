# frozen_string_literal: true

module CivilServantHelper
  def personal_information_table(civil_servant = current_civil_servant)
    TabularCardComponent.humanize_table_values(
      CivilServant,
      zdp: civil_servant.zdp,
      first_name: civil_servant.first_name,
      last_name: civil_servant.last_name,
      hometown: civil_servant.hometown,
      birthday: I18n.l(civil_servant.birthday),
      phone: civil_servant.phone
    )
  end

  def personal_information_table_without_name(civil_servant = current_civil_servant)
    TabularCardComponent.humanize_table_values(
      CivilServant,
      zdp: civil_servant.zdp,
      hometown: civil_servant.hometown,
      birthday: I18n.l(civil_servant.birthday),
      phone: civil_servant.phone
    )
  end

  def address_information_table(civil_servant = current_civil_servant)
    address = civil_servant.address

    TabularCardComponent.humanize_table_values(
      Address,
      primary_line: address.primary_line,
      secondary_line: address.secondary_line,
      street: address.street,
      supplement: address.supplement,
      city: address.city,
      zip: address.zip
    )
  end

  def login_information_table(civil_servant = current_civil_servant)
    user = civil_servant.user

    TabularCardComponent.humanize_table_values(
      User,
      email: user.email,
      language: I18n.t(user.language, scope: %i[activerecord attributes user languages])
    )
  end

  def bank_and_insurance_information_table(civil_servant = current_civil_servant)
    TabularCardComponent.humanize_table_values(
      CivilServant,
      iban: civil_servant.prettified_iban,
      health_insurance: civil_servant.health_insurance
    )
  end

  def service_specific_information_table(civil_servant = current_civil_servant)
    TabularCardComponent.humanize_table_values(
      CivilServant,
      regional_center: civil_servant.regional_center.name,
      workshops: civil_servant.workshops.pluck(:name).to_sentence,
      driving_licenses: civil_servant.driving_licenses.pluck(:name).to_sentence
    )
  end
end
