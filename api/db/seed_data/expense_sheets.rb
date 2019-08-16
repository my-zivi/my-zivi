# frozen_string_literal: true

Service.all.each { |service| ExpenseSheetGenerator.new(service).create_expense_sheets }
