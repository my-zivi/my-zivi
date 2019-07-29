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
            label: I18n.t('activerecord.models.attributes.user.last_name').sub(/\w/, &:capitalize) +
              ", #{I18n.t('activerecord.models.attributes.user.first_name')}:",
            content: ->(expense_sheet) { "<b>#{expense_sheet.user.full_name}</b>" }
          },
          {
            label: "#{I18n.t('activerecord.models.attributes.user.address')}:",
            content: ->(expense_sheet) { expense_sheet.user.address }
          },
          {
            label: "#{I18n.t('activerecord.models.attributes.user.zdp').sub(/\w/, &:capitalize)}:",
            content: ->(expense_sheet) { expense_sheet.user.zip }
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
            label: "<b>#{I18n.t('activerecord.models.attributes.user.bank_iban')}:</b>",
            content: ->(expense_sheet) { "<b>#{IBANTools::IBAN.new(expense_sheet.user.bank_iban).prettify}</b>" }
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
