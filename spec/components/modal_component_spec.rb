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

  context 'with body content_area' do
    subject(:component) do
      described_class.new(modal_id: modal_id, title: title) do |component|
        component.with(:body, 'Hello from the body')
      end
    end

    let(:rendered) do
      render_inline(component) do |component|
        component.with(:body, body_content)
      end
    end
    let(:body_content) { 'Hello from the body' }

    it 'renders body content' do
      expect(rendered.css('.modal-content div:nth-child(2)').text).to eq body_content
    end
  end
end
