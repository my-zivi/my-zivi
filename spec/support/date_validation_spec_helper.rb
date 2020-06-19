# frozen_string_literal: true

RSpec.shared_examples_for 'validates that the ending is after beginning' do
  describe '#ending' do
    subject do
      model.tap(&:validate).errors.added? :ending, :after, restriction: beginning.strftime('%Y-%m-%d %H:%M:%S')
    end

    let(:beginning) { Time.zone.today.at_beginning_of_week }
    let(:ending) { beginning.at_end_of_week - 2.days }

    context 'when ending is after beginning' do
      it { is_expected.to be false }
    end

    context 'when ending is at beginning' do
      let(:ending) { beginning }

      it { is_expected.to be true }
    end

    context 'when ending is before beginning' do
      let(:ending) { beginning - 2.days }

      it { is_expected.to be true }
    end
  end
end
