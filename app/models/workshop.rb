# frozen_string_literal: true

class Workshop < ApplicationRecord
  validates :name, presence: true
end
