# frozen_string_literal: true

module Subscriptions
  class Base < ApplicationRecord
    self.table_name = 'subscriptions'

    belongs_to :organization
  end
end
