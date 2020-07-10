# frozen_string_literal: true

module ServiceAgreementForm
  module RenameMapping
    GERMAN_RENAMING = YAML.safe_load(
      File.read(
        Rails.root.join('lib/services/service_agreement_form/german_renaming.yaml')
      ),
      [Symbol]
    )[:fields].freeze

    FRENCH_RENAMING = YAML.safe_load(
      File.read(
        Rails.root.join('lib/services/service_agreement_form/french_renaming.yaml')
      ),
      [Symbol]
    )[:fields].freeze
  end
end
