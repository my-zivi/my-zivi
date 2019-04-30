# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:last_name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:address) }
  it { is_expected.to validate_presence_of(:bank_iban) }
  it { is_expected.to validate_presence_of(:birthday) }
  it { is_expected.to validate_presence_of(:city) }
  it { is_expected.to validate_presence_of(:health_insurance) }
  it { is_expected.to validate_presence_of(:role) }
  it { is_expected.to validate_presence_of(:zip) }
  it { is_expected.to validate_presence_of(:hometown) }
  it { is_expected.to validate_presence_of(:phone) }
  it { is_expected.to validate_numericality_of(:zip).only_integer }

  it do
    expect(described_class.new).to validate_numericality_of(:zdp)
      .only_integer
      .is_less_than(999_999)
      .is_greater_than(25_000)
  end

  describe '#bank_iban' do
    it { is_expected.not_to allow_value('CH93 0076 2011 6238 5295 7').for(:bank_iban) }
    it { is_expected.not_to allow_value('CH93007620116238529577').for(:bank_iban) }
    it { is_expected.not_to allow_value('CH9300762011623852956').for(:bank_iban) }
    it { is_expected.not_to allow_value('XX9300762011623852957').for(:bank_iban) }
    it { is_expected.to allow_value('CH9300762011623852957').for(:bank_iban) }
  end
end
