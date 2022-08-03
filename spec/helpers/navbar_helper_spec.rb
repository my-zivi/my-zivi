# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NavbarHelper do
  describe '#navbar_link' do
    subject(:link) { helper.navbar_link('MyLink', '/my-path') }

    it 'creates a sidebar link' do
      expect(link).to eq '<li class="nav-item"><a class="nav-link" href="/my-path">MyLink</a></li>'
    end

    context 'when it\'s the current page' do
      before do
        allow(helper).to receive(:current_page?).and_return true
      end

      it 'creates an active sidebar link' do
        expect(link).to include 'nav-item active font-weight-bold'
      end
    end
  end
end
