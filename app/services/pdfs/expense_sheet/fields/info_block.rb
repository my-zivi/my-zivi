# frozen_string_literal: true

module Pdfs
  module ExpenseSheet
    module Fields
      module InfoBlock
        HEADER_ROWS = [
          {
            label: "#{I18n.t('activerecord.models.service_specification').sub(/\w/, &:capitalize)}:",
            content: ->(expense_sheet) { expense_sheet.service.service_specification.title }
          },
          {
            label: I18n.t('activerecord.attributes.civil_servant.last_name').sub(/\w/, &:capitalize) +
              ", #{I18n.t('activerecord.attributes.civil_servant.first_name')}:",
            content: ->(expense_sheet) { "<b>#{expense_sheet.service.civil_servant.full_name}</b>" }
          },
          {
            label: "#{I18n.t('activerecord.attributes.address.street')}:",
            content: lambda { |expense_sheet|
              "#{expense_sheet.service.civil_servant.address}, " \
              "#{expense_sheet.service.civil_servant.address.zip_with_city} "
            }
          },
          {
            label: "#{I18n.t('activerecord.attributes.civil_servant.zdp').sub(/\w/, &:capitalize)}:",
            content: ->(expense_sheet) { expense_sheet.service.civil_servant.zdp }
          },
          {
            label: "#{I18n.t('pdfs.expense_sheet.info_block.header.complete_service.label')}:",
            content: lambda do |expense_sheet|
                       service = expense_sheet.service
                       service_days = service.service_days
                       I18n.t('pdfs.expense_sheet.info_block.header.complete_service.value',
                              beginning: I18n.l(service.beginning),
                              ending: I18n.l(service.ending),
                              duration: service_days,
                              count: service_days)
                     end
          },
          {
            label: "#{I18n.t('pdfs.expense_sheet.info_block.header.expense_sheet_time_duration.label')}:",
            content: lambda do |expense_sheet|
                       duration = expense_sheet.duration
                       I18n.t('pdfs.expense_sheet.info_block.header.expense_sheet_time_duration.value',
                              beginning: I18n.l(expense_sheet.beginning),
                              ending: I18n.l(expense_sheet.ending),
                              duration: duration,
                              count: duration)
                     end
          }
        ].freeze

        FOOTER_ROWS = [
          {
            label: "<b>#{I18n.t('activerecord.attributes.civil_servant.iban')}:</b>",
            content: lambda do |expense_sheet|
              "<b>#{IBANTools::IBAN.new(expense_sheet.service.civil_servant.iban).prettify}</b>"
            end
          },
          {
            label: "<b>#{I18n.t('pdfs.expense_sheet.info_block.footer.bank_account_number')}:</b>",
            content: '4470 (200)'
          }
        ].freeze
      end
    end
  end
end
