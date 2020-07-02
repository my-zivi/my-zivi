# frozen_string_literal: true

require_relative '../services/service_agreement_form/field_preparer'
require_relative '../services/service_agreement_form/rename_mapping'

namespace :service_agreement_form do

  desc 'Renames all the form fields to match our internal form fields naming'
  task rename_fields: :environment do
    FRENCH_FILE_PATH = Rails.root.join('lib/assets/pdfs/french_service_agreement_form.pdf').to_s.freeze
    GERMAN_FILE_PATH = Rails.root.join('lib/assets/pdfs/german_service_agreement_empty.pdf').to_s.freeze

    ServiceAgreementForm::FieldPreparer.prepare_fields(
      GERMAN_FILE_PATH, ServiceAgreementForm::RenameMapping::GERMAN_RENAMING
    )
  end
end
