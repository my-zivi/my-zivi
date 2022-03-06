# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ServiceInquiry, type: :model do
  describe 'validations' do
    subject(:model) { described_class.new }

    it_behaves_like 'validates presence of required fields', %i[name email service_beginning service_ending message]
  end
end
