# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Faq, type: :model do
  subject(:model) { build(:faq).tap(&:validate) }

  it_behaves_like 'validates presence of required fields', %i[
    question
    answer
  ]
end
