# frozen_string_literal: true

class Administrator < ApplicationRecord
  belongs_to :organization
  has_one :user, as: :referencee, dependent: :destroy
end
