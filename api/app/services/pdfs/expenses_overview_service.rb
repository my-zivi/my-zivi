# frozen_string_literal: true

require 'prawn'

module Pdfs
  class ExpensesOverviewService
    include Prawn::View
    include Pdfs::PrawnHelper

    TABLE_CELL_STYLE = {
      cell_style: { borders: [], padding: [0, 5, 0, 5] },
      width: bounds.width, column_widths: Pdfs::ExpensesOverview::ExpensesOverviewAdditions::COLUMN_WIDTHS
    }.freeze

    def initialize(service_specifications, dates)
      @beginning = dates.beginning
      @ending = dates.ending
      @service_specifications = service_specifications
      update_font_families
      headline
      header
      content_table
    end

    def document
      @document ||= Prawn::Document.new(page_size: 'A4', page_layout: :landscape)
    end

    private

    def headline
      text I18n.t('pdfs.expenses_overview.swo', date: I18n.l(Time.zone.today)), align: :right, size: 8
      text I18n.t('pdfs.expenses_overview.basedon', date: I18n.l(Time.zone.today)), align: :right, size: 8
      text(I18n.t('pdfs.expenses_overview.title', beginning: I18n.l(@beginning), ending: I18n.l(@ending)),
           align: :left, style: :bold, size: 15)
    end

    def header
      font_size 9
      table([Pdfs::ExpensesOverview::ExpensesOverviewAdditions::TABLE_HEADER,
             Pdfs::ExpensesOverview::ExpensesOverviewAdditions::TABLE_SUB_HEADER],
            cell_style: { borders: [] }, width: bounds.width,
            column_widths: Pdfs::ExpensesOverview::ExpensesOverviewAdditions::COLUMN_WIDTHS) do
        row(0).font_style = :bold
      end
    end

    def content_table
      total_days = 0
      total_expenses = 0.0
      font_size 9
      @service_specifications.each_value do |expense_sheet|
        content_table_row(expense_sheet)
        total_days += (expense_sheet.sum(&:work_days) + expense_sheet.sum(&:workfree_days) +
          expense_sheet.sum(&:paid_vacation_days) + expense_sheet.sum(&:sick_days))
        total_expenses += expense_sheet.sum(&:calculate_full_expenses)
      end
      total_sum_table(total_days, total_expenses)
    end

    def content_table_row(expense_sheet)
      table(
        table_data(expense_sheet),
        TABLE_CELL_STYLE
      )
      sum_table(expense_sheet)
    end

    # :reek:FeatureEnvy
    def sum_table(expense_sheets)
      table([[{ content: 'Gesamt: ', align: :left },
              { content: (expense_sheets.sum(&:work_days) + expense_sheets.sum(&:workfree_days) +
                expense_sheets.sum(&:paid_vacation_days) + expense_sheets.sum(&:sick_days)).to_s,
                align: :right },
              { content: Pdfs::ExpenseSheet::FormatHelper.to_chf(expense_sheets.sum(&:calculate_full_expenses).to_s),
                align: :right }]], cell_style: { borders: [], padding: [1, 5, 1, 5] },
                                   header: false, position: :right, column_widths: [40, 30, 45]) do
        row(0).font_style = :bold
      end
    end

    def total_sum_table(total_days, total_expenses)
      table([[{ content: 'Total Tage: ' + total_days.to_s + ', Total Betrag: ' +
        Pdfs::ExpenseSheet::FormatHelper.to_chf(total_expenses.to_s), align: :right }]],
            cell_style: { borders: [] }, header: false, position: :right) do
        row(0).font_style = :italic
      end
    end

    def pre_table(name)
      move_down 25
      text(name, align: :left, style: :bold, size: 11)
    end

    def table_data(expense_sheets)
      move_down 10
      table_content(expense_sheets)
    end

    def table_content(expense_sheets)
      expense_sheets.map do |expense_sheet|
        expense_sheet.slice.values

        expense_sheet_parts = Pdfs::ExpensesOverview::ExpensesOverviewTableParts.new expense_sheet
        expense_sheet_parts.all_parts
      end
    end
  end
end
