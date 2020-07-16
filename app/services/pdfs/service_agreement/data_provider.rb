# frozen_string_literal: true

module Pdfs
  module ServiceAgreement
    class DataProvider
      def self.evaluate_data_hash(data_hash, **lambda_parameters)
        data_hash.transform_values do |field_value_lambda|
          field_value_lambda.call(**lambda_parameters)
        end
      end
    end
  end
end
