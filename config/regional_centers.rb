# frozen_string_literal: true

Rails.application.configure do
  config.x.regional_centers = {
    'rüti' => {
      name: 'Regionalzentrum Rüti/ZH',
      address: {
        primary_line: 'Vollzugsstelle für den Zivildienst ZIVI',
        secondary_line: 'Regionalzentrum Rüti (ZH)',
        street: 'Spitalstrasse 31',
        supplement: 'Postfach',
        city: 'Rüti',
        zip: 8630
      }
    },
    'thun' => {
      name: 'Regionalzentrum Thun',
      address: {
        primary_line: 'Vollzugsstelle für den Zivildienst ZIVI',
        secondary_line: 'Regionalzentrum Thun',
        street: 'Malerweg 6',
        city: 'Thun',
        zip: 3600
      }
    }
  }.freeze
end
