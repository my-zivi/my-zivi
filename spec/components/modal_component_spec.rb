# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ModalComponent, type: :component do
  subject(:component) do
    described_class.new(modal_id: modal_id, title: title)
  end

  let(:rendered) { render_inline(component) }
  let(:modal_id) { 'my-modal-id' }
  let(:title) { 'My title' }

  it 'renders id and title' do
    expect(rendered.css('h5').text).to eq title
    expect(rendered.css("##{modal_id}-modal-title").text).to eq title
    expect(rendered.css('.modal.fade').attr('id').value).to eq modal_id
  end
end
