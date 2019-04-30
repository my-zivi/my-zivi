# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Holiday, type: :model do
  it { is_expected.to validate_presence_of :beginning }
  it { is_expected.to validate_presence_of :ending }
  it { is_expected.to validate_presence_of :holiday_type }
  it { is_expected.to validate_presence_of :description }

  it_behaves_like 'validates that the ending is after beginning' do
    let(:model) { build(:holiday, beginning: beginning, ending: ending) }
  end
end
