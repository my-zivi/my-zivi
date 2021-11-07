# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NavItemHelper, type: :helper do
  describe '#nav_item_class' do
    subject(:nav_item_class) { helper.nav_item_class('page') }

    before do
      allow(helper).to receive(:breadcrumb_trail).and_return([Loaf::Breadcrumb['name', current_page_path, false]])
    end

    context 'when it is current page' do
      let(:current_page_path) { 'page' }

      it { is_expected.to eq 'active' }
    end

    context 'when it is not current page' do
      let(:current_page_path) { 'other_page' }

      it { is_expected.to eq '' }
    end
  end
end
