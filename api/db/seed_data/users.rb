# frozen_string_literal: true

User.create!(
  [
    {
      email: 'zivi@example.com',
      first_name: 'Zivi',
      last_name: 'Example',
      password: '123456',
      address: 'Zivistrasse 12a',
      bank_iban: 'CH9300762011623852957',
      birthday: Time.zone.today - 18.years,
      city: 'Zivistadt',
      health_insurance: 'Militärversicherung',
      zip: '4231',
      hometown: 'Better Zivitown',
      phone: '076 987 65 43',
      zdp: 739_539,
      regional_center: RegionalCenter.find_by(short_name: 'Ru')
    },
    {
      email: 'zivi2@example.com',
      first_name: 'Zivi2',
      last_name: 'Example',
      password: '123456',
      address: 'Zivistrasse 12b',
      bank_iban: 'CH9300762011623852957',
      birthday: Time.zone.today - 19.years,
      city: 'Zivistadt',
      health_insurance: 'Militärversicherung',
      zip: '4231',
      hometown: 'Better Zivitown',
      phone: '076 876 54 32',
      zdp: 739_540,
      regional_center: RegionalCenter.find_by(short_name: 'Ru')
    },
    {
      email: 'zivi_francise@france.ch',
      first_name: 'Französische',
      last_name: 'Zivi',
      password: '123456',
      address: 'Franzenstrasse 12b',
      bank_iban: 'CH9300762011623852957',
      birthday: Time.zone.today - 21.years,
      city: 'Civilvillage',
      health_insurance: 'Versicherund d\'Armee',
      zip: '4242',
      hometown: 'Meilleur Village',
      phone: '076 876 54 32',
      zdp: 739_541,
      regional_center: RegionalCenter.find_by(short_name: 'Th')
    },
    {
      email: 'admin@example.com',
      first_name: 'Admin',
      last_name: 'Boss',
      password: '123456',
      address: 'Zivistrasse 12b',
      bank_iban: 'CH9300762011623852957',
      birthday: Time.zone.today - 19.years,
      city: 'Zivistadt',
      health_insurance: 'Militärversicherung',
      zip: '4231',
      hometown: 'Better Zivitown',
      phone: '076 876 54 32',
      zdp: 739_542,
      regional_center: RegionalCenter.find_by(short_name: 'Ru'),
      role: :admin
    }
  ]
)
