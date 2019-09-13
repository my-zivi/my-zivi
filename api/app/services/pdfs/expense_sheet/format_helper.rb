# frozen_string_literal: true

module Pdfs
  module ExpenseSheet
    module FormatHelper
      def self.to_chf(expense)
        format('%.2f', expense.to_d / 100)
      end
    end
  end
end
