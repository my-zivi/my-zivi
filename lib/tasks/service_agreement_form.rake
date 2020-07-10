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

    pdf = FillablePDF.new(GERMAN_FILE_PATH)
    pdf.names.each do |name|
      pdf.set_field(name, name)
    end
    pdf.save_as Rails.root.join('lib/assets/pdfs/german_service_agreement_form_field_names.pdf').to_s
    pdf.close

    # pdf2 = FillablePDF.new(Rails.root.join('lib/assets/pdfs/german_service_agreement_form_original.pdf').to_s)
    # pdf2.names.each do |name|
    #   pdf2.set_field(name, name)
    # end
    # pdf2.save_as Rails.root.join('lib/assets/pdfs/german_service_agreement_form_o_field_names.pdf').to_s
    # pdf2.close
  end
end
