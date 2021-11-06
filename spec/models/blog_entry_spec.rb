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

  describe '.including_tags' do
    subject { described_class.including_tags('article') }

    let!(:articles) do
      [create(:blog_entry, title: 'Article', tags: %w[article]),
       create(:blog_entry, title: 'Article about Podcasts', tags: %w[article podcast]),
       create(:blog_entry, tags: %w[podcast]),
       create(:blog_entry, tags: %w[podcast news])]
    end

    it { is_expected.to contain_exactly(articles.first, articles.second) }

    context 'when filtering for news tag' do
      subject { described_class.including_tags('news') }

      it { is_expected.to contain_exactly(articles.fourth) }
    end

    context 'when filtering for multiple tags' do
      subject { described_class.including_tags('article', 'news') }

      it { is_expected.to contain_exactly(articles.first, articles.second, articles.fourth) }
    end

    context 'when filter is empty' do
      it { expect { described_class.including_tags }.to raise_error(ArgumentError) }
    end
  end
end
