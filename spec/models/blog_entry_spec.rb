# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BlogEntry, type: :model do
  subject(:model) { described_class.new }

  it_behaves_like 'validates presence of required fields', %i[title author content]
end
