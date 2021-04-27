# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobPosting, type: :model do
  subject(:model) { described_class.new }

  it_behaves_like 'validates presence of required fields', %i[link title publication_date description]

  it 'validates uniqueness of link' do
    expect(model).to validate_uniqueness_of(:link)
  end
end
