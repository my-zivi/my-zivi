# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CardAccordionEntryComponent, type: :component do
  subject(:rendered) { render_inline(component) }

  let(:component) { described_class.new(title: 'My title', parent_id: 'parent') }

  it 'produces an accordion entry' do
    expect(rendered.css('.card-header').attr('id').value).to match(/heading-entry-.{11}/)
    expect(rendered.css('button').attr('data-target').value).to match(/#entry-.{11}/)
    expect(rendered.to_s).to include 'data-parent="#parent"'
  end

  context 'when entry is expanded' do
    let(:component) { described_class.new(title: 'My title', parent_id: 'parent', expanded: true) }

    it 'has an expanded entry' do
      expect(rendered.css('.show')).not_to be_empty
    end
  end
end
