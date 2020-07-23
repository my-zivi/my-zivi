# frozen_string_literal: true

module CivilServants
  module CivilServantHelper
    def personal_information_table
      humanize_table(
        CivilServant,
        zdp: current_civil_servant.zdp,
        first_name: current_civil_servant.first_name,
        last_name: current_civil_servant.last_name,
        hometown: current_civil_servant.hometown,
        birthday: I18n.l(current_civil_servant.birthday),
        phone: current_civil_servant.phone
      )
    end

    def address_information_table
      address = current_civil_servant.address

      humanize_table(
        Address,
        primary_line: address.primary_line,
        secondary_line: address.secondary_line,
        street: address.street,
        supplement: address.supplement,
        city: address.city,
        zip: address.zip
      )
    end

    def login_information_table
      user = current_civil_servant.user

      humanize_table(
        User,
        email: user.email,
        language: I18n.t(user.language, scope: %i[activerecord attributes user languages])
      )
    end

    def bank_and_insurance_information_table
      humanize_table(
        CivilServant,
        iban: current_civil_servant.iban,
        health_insurance: current_civil_servant.health_insurance
      )
    end

    def service_specific_information_table
      humanize_table(
        CivilServant,
        regional_center: current_civil_servant.regional_center.name,
        workshops: current_civil_servant.workshops.pluck(:name).to_sentence,
        driving_licenses: current_civil_servant.driving_licenses.pluck(:name).to_sentence
      )
    end

    private

    def humanize_table(values_klass, **information_table)
      information_table
        .select { |_key, value| value.present? }
        .transform_keys(&values_klass.method(:human_attribute_name))
    end
  end
end
