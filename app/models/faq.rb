# frozen_string_literal: true

class Faq < ApplicationRecord
  validates :question, :answer, presence: true
end
