# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NavItemHelper, type: :helper do
  describe '#nav_item_class' do
    subject(:nav_item_class) { helper.nav_item_class('page') }

    before { allow(helper).to receive(:current_page?).and_return current_page_value }

    context 'when it is current page' do
      let(:current_page_value) { true }

      it { is_expected.to eq 'active' }
    end

    context 'when it is not current page' do
      let(:current_page_value) { false }

      it { is_expected.to eq '' }
    end
  end
end
