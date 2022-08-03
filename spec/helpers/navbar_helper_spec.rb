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

  describe '#dropdown_navbar_link' do
    subject(:dropdown) { helper.dropdown_navbar_link('MyDropdown', '/my-path', *dropdown_items) }

    let(:dropdown_items) { [helper.dropdown_item('MyItem', '/my-item-path')] }

    it 'creates a dropdown link' do
      expect(dropdown).to eq(<<~HTML.squish.gsub(/> </, '><'))
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" role="button" data-toggle="dropdown" aria-expanded="false" href="/my-path">MyDropdown</a>
          <div class="dropdown-menu dropdown-menu-card dropdown-caret mt-0">
            <div class="bg-white py-2">
              <a class="dropdown-item " href="/my-item-path">MyItem</a>
            </div>
          </div>
        </li>
      HTML
    end
  end
end
