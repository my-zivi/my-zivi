# frozen_string_literal: true

module Pdfs
  module ExpenseSheet
    module FormatHelper
      def self.to_chf(expense)
        format('%<expense>.2f', expense: expense.to_d / 100)
      end
    end
  end
end
