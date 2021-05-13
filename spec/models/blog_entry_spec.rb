# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BlogEntry, type: :model do
  subject(:model) { described_class.new }

  describe 'validation' do
    it_behaves_like 'validates presence of required fields', %i[title author content description slug]

    describe 'slug format' do
      let(:blog_entry) { build(:blog_entry, slug: 'my invalid slug') }

      before { blog_entry.validate }

      it 'has an error' do
        expect(blog_entry.errors[:slug]).not_to be_empty
      end
    end
  end

  describe '#to_param' do
    subject { build(:blog_entry, slug: 'hey-there').to_param }

    it { is_expected.to eq 'hey-there' }
  end

  describe 'slug auto generation' do
    subject { blog_entry.slug }

    let(:blog_entry) { build(:blog_entry, title: 'My cool Blog') }

    it { is_expected.to be_nil }

    context 'when blog entry gets validated' do
      before { blog_entry.validate }

      it { is_expected.to eq 'my-cool-blog' }
    end

    context 'when blog entry already has a slug' do
      let(:blog_entry) { build(:blog_entry, slug: 'custom') }

      it 'does not change the slug when validating' do
        expect { blog_entry.validate }.not_to change(blog_entry, :slug)
      end
    end

    context 'when title is nil' do
      let(:blog_entry) { build(:blog_entry, title: nil) }

      it 'does not attempt to generate a slug' do
        expect { blog_entry.validate }.not_to change(blog_entry, :slug)
      end
    end
  end
end
