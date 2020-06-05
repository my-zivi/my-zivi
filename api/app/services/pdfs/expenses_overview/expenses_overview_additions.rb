# frozen_string_literal: true

module Pdfs
  module ExpensesOverview
    class ExpensesOverviewAdditions
      COLOR_GREY = 'DDDDDD'

      TABLE_HEADER = [
        {
          content: I18n.t('activerecord.attributes.user.id'),
          background_color: COLOR_GREY, align: :center
        },
        {
          content: I18n.t('activerecord.attributes.service_specification.name'),
          background_color: COLOR_GREY, align: :center
        },
        {
          content: I18n.t('pdfs.expense_sheet.info_block.header.expense_sheet_time_duration.label'),
          background_color: COLOR_GREY, align: :center
        },
        {
          content: I18n.t('activerecord.attributes.expense_sheet.work_days.other'),
          colspan: 2, background_color: COLOR_GREY, align: :center
        },
        {
          content: I18n.t('activerecord.attributes.expense_sheet.workfree'),
          colspan: 2, background_color: COLOR_GREY, align: :center
        },
        {
          content: I18n.t('activerecord.attributes.expense_sheet.sickness'),
          colspan: 2, background_color: COLOR_GREY, align: :center
        },
        {
          content: I18n.t('activerecord.attributes.expense_sheet.paid_vacation_days.other'),
          colspan: 2, background_color: COLOR_GREY, align: :center
        },
        {
          content: I18n.t('activerecord.attributes.expense_sheet.unpaid_vacation_days.other'),
          colspan: 2, background_color: COLOR_GREY, align: :center
        },
        {
          content: I18n.t('activerecord.attributes.expense_sheet.way_expenses'),
          background_color: COLOR_GREY, align: :center
        },
        {
          content: I18n.t('activerecord.attributes.expense_sheet.clothing'),
          colspan: 2, background_color: COLOR_GREY, align: :center
        },
        {
          content: I18n.t('pdfs.expense_sheet.expense_table.row_headers.extra'),
          background_color: COLOR_GREY, align: :center
        },
        {
          content: I18n.t('pdfs.expense_sheet.expense_table.headers.full_amount'),
          colspan: 2, background_color: COLOR_GREY, align: :right
        }
      ].freeze

      TABLE_SUB_HEADER = [
        {},
        {},
        {},
        ([
          { content: 'Tage', background_color: COLOR_GREY, align: :left },
          { content: 'Fr.', background_color: COLOR_GREY, align: :right }
        ] * 8)...
      ].freeze

      COLUMN_WIDTHS = [40, 90, 80, 30, 35, 30, 35, 30, 35, 30, 35, 30, 35, 60, 30, 30, 40, 30].freeze
    end
  end
end
