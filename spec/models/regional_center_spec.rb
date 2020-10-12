# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegionalCenter, type: :model do
  subject(:model) { described_class.new }

  describe 'validations' do
    it_behaves_like 'validates presence of required fields', %i[name address]
  end

  describe '.all' do
    subject(:all) { described_class.all }

    it 'returns all registered regional centers' do
      expect(all).not_to be_empty
      expect(all.map(&:identifier)).to contain_exactly(*Rails.configuration.x.regional_centers.keys)
    end
  end

  describe '.find' do
    it 'returns the regional center which matches the identifier given' do
      center = described_class.find('rüti')
      expect(center.identifier).to eq 'rüti'
      expect(center.name).to match 'Regionalzentrum Rüti'
    end

    context 'when the identifier is not known' do
      it { expect(described_class.find('blubbs')).to be_nil }
    end
  end

  describe 'convenience accessors' do
    it 'defines inflected convenience accessors for each regional center' do
      expect(described_class.rueti).to be_a(described_class)
    end

    it 'does not define accessors for centers that do not exist' do
      expect { described_class.blubbs }.to raise_error(NoMethodError)
    end
  end
end
