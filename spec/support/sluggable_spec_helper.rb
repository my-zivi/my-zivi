# frozen_string_literal: true

RSpec.shared_examples_for 'sluggable model' do |factory_name:|
  describe 'slug format validation' do
    let(:model) { build(factory_name, slug: 'my invalid slug') }

    before { model.validate }

    it 'has an error' do
      expect(model.errors[:slug]).not_to be_empty
    end
  end

  describe '#to_param' do
    subject { model.to_param }

    let(:model) { build(factory_name, slug: 'hey-there') }

    it { is_expected.to eq 'hey-there' }

    context 'when slug is empty' do
      let(:model) { build(factory_name, slug: nil) }

      it { is_expected.to be_nil }
    end
  end

  describe 'slug auto generation' do
    subject { model.slug }

    let(:model) { build(factory_name) }

    it { is_expected.to be_nil }

    context 'when model gets validated' do
      before { model.validate }

      it { is_expected.to eq model.default_slug }
    end

    context 'when model already has a slug' do
      let(:model) { build(factory_name, slug: 'custom') }

      it 'does not change the slug when validating' do
        expect { model.validate }.not_to change(model, :slug)
      end
    end

    context 'when title is nil' do
      let(:model) { build(factory_name, title: nil) }

      it 'does not attempt to generate a slug' do
        expect { model.validate }.not_to change(model, :slug)
      end
    end
  end
end
