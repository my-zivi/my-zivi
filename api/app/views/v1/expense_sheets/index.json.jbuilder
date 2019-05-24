# frozen_string_literal: true

json.array! @expense_sheets, partial: 'expense_sheet', as: :expense_sheet
