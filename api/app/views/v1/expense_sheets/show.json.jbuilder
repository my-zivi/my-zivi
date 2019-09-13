# frozen_string_literal: true

json.partial! 'expense_sheet', expense_sheet: @expense_sheet
json.service_id @expense_sheet.service.id
