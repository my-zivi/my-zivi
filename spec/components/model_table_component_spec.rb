# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ModelTableComponent, type: :component do
  subject(:rendered) { render_inline(component) }

  let(:component) do
    described_class.new(model_data: [model],
                        model_columns: columns)
  end
  let(:columns) do
    {
      that: {
        sort: true,
        label: 'The label',
        content: ->(model) { model.something }
      },
      the_other: {
        label: 'The other label',
        content: ->(model) { model.other }
      }
    }
  end
  let(:model) do
    OpenStruct.new(
      something: 'lala',
      other: 'Hans'
    )
  end

  let(:rendered_column) { rendered.css('td').map(&:text).reject(&:empty?) }
  let(:rendered_header) { rendered.css('th').map(&:text).reject(&:empty?) }

  it 'renders a table of model data' do
    expect(rendered.to_s).to include(*columns.values.pluck(:label))
    expect(rendered.css('tr').length).to eq 2
    expect(rendered_column).to(
      contain_exactly('lala', 'Hans')
    )
  end

  context 'when specifying custom actions' do
    let(:actions) do
      {
        edit: {
          icon_classes: 'fas fa-pen',
          link_path: ->(_model) { 'the_super_url' },
          link_args: {
            class: 'mr-3',
            title: 'edit',
            data: { toggle: 'tooltip', placement: 'above' }
          }
        }
      }
    end
    let(:component) { described_class.new(model_data: [model], model_columns: columns, model_actions: actions) }

    it 'renders the specified actions' do
      expect(rendered.css('td i').length).to eq 1
      expect(rendered.css('td i').attr('class').value).to eq 'fas fa-pen'
      expect(rendered.css('td a').attr('href').value).to eq 'the_super_url'
      expect(rendered.css('td a').attr('data-toggle').value).to eq 'tooltip'
      expect(rendered.css('td a').attr('data-placement').value).to eq 'above'
    end
  end
end
