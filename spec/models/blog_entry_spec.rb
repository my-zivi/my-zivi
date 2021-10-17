# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BlogEntry, type: :model do
  subject(:model) { described_class.new }

  it_behaves_like 'sluggable model', factory_name: :blog_entry

  describe 'validation' do
    it_behaves_like 'validates presence of required fields', %i[title author content description slug]

    describe 'tags' do
      it 'only allows supported tags' do
        expect(build(:blog_entry, tags: described_class::SUPPORTED_TAGS)).to be_valid
        expect(build(:blog_entry, tags: [])).to be_valid
        expect(build(:blog_entry, tags: %w[imaginary invalid])).not_to be_valid
        expect(build(:blog_entry, tags: [described_class::SUPPORTED_TAGS.first, 'invalid'])).not_to be_valid
      end
    end
  end
end
