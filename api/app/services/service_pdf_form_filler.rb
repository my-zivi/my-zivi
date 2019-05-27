# frozen_string_literal: true

require 'pdf_forms'

class ServicePdfFormFiller
  FRENCH_FILE_PATH = Rails.root.join('app', 'assets', 'pdfs', 'french_service_agreement.pdf').freeze
  GERMAN_FILE_PATH = Rails.root.join('app', 'assets', 'pdfs', 'german_service_agreement.pdf').freeze

  attr_reader :result_file_path

  def initialize(service)
    @service = service
  end

  # TODO: Add unpaid_company_holiday_days
  def fill_service_agreement
    I18n.locale = valais? ? :fr : :de

    file_path = valais? ? FRENCH_FILE_PATH : GERMAN_FILE_PATH
    result_file_name = "#{Time.now.in_time_zone.strftime '%Y%m%d%H%M%S'}.pdf"
    @result_file_path = Rails.root.join('tmp', result_file_name)

    pdftk.fill_form file_path, result_file_path, load_fields, flatten: true
  end

  private

  def pdftk
    @pdftk ||= PdfForms.new('/usr/bin/pdftk')
  end

  def load_fields
    load_user_fields
      .merge(load_service_date_fields)
      .merge(load_service_checkboxes)
      .merge(load_service_specification_fields)
  end

  def load_user_fields
    convert_to_form_fields_hash(ServicePdfFields::USER_FORM_FIELDS) do |key, value|
      [value, @service.user.public_send(key)]
    end
  end

  def load_service_date_fields
    convert_to_form_fields_hash(ServicePdfFields::SERVICE_DATE_FORM_FIELDS) do |key, value|
      [value, I18n.l(@service.public_send(key))]
    end
  end

  def load_service_checkboxes
    convert_to_form_fields_hash(ServicePdfFields::SERVICE_CHECKBOX_FIELDS) do |key, value|
      [value, (@service.public_send(:"#{key}?") ? 'On' : 'Off')]
    end
  end

  def load_service_specification_fields
    convert_to_form_fields_hash(ServicePdfFields::SERVICE_SPECIFICATION_FORM_FIELDS) do |key, value|
      [value, @service.service_specification.public_send(key)]
    end
  end

  def convert_to_form_fields_hash(mapping, &block)
    mapping[I18n.locale].map(&block).to_h
  end

  def valais?
    @service.service_specification.location_valais?
  end
end
