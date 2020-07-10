# frozen_string_literal: true

require_relative '../services/service_agreement_form/field_preparer'
require_relative '../services/service_agreement_form/rename_mapping'

namespace :service_agreement_form do
  desc 'Renames all the form fields to match our internal form fields naming'
  task rename_fields: :environment do
    FRENCH_FILE_PATH = Rails.root.join('lib/assets/pdfs/french_service_agreement_form.pdf').to_s.freeze
    GERMAN_FILE_PATH = Rails.root.join('lib/assets/pdfs/german_service_agreement_form.pdf').to_s.freeze

    ServiceAgreementForm::FieldPreparer.prepare_fields(
      GERMAN_FILE_PATH, ServiceAgreementForm::RenameMapping::GERMAN_RENAMING
    )

    ServiceAgreementForm::FieldPreparer.prepare_fields(
      FRENCH_FILE_PATH, ServiceAgreementForm::RenameMapping::FRENCH_RENAMING
    )
  end

  desc 'Fill the form field names into the form fields'
  task fill_fields_with_names: :environment do
    FRENCH_FILE_O_PATH_SRC = Rails.root.join('lib/assets/pdfs/french_service_agreement_form_original.pdf').to_s.freeze
    GERMAN_FILE_O_PATH_SRC = Rails.root.join('lib/assets/pdfs/german_service_agreement_form_original.pdf').to_s.freeze
    FRENCH_FILE_O_PATH_DEST = Rails.root.join('lib/assets/pdfs/french_sa_form_o_field_names.pdf').to_s.freeze
    GERMAN_FILE_O_PATH_DEST = Rails.root.join('lib/assets/pdfs/german_sa_form_o_field_names.pdf').to_s.freeze

    ServiceAgreementForm::FieldPreparer.fill_fields_with_field_name(
      FRENCH_FILE_O_PATH_SRC, FRENCH_FILE_O_PATH_DEST
    )
    ServiceAgreementForm::FieldPreparer.fill_fields_with_field_name(
      GERMAN_FILE_O_PATH_SRC, GERMAN_FILE_O_PATH_DEST
    )
  end
end
