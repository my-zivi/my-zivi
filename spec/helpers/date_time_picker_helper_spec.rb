# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DateTimePickerHelper, type: :helper do
  describe '#date_picker' do
    subject(:date_picker_input_element) { Nokogiri::HTML(date_picker_html).at_xpath('//*[@id="object_date"]') }

    let(:date_picker_html) do
      helper.simple_form_for :object, url: root_path do |f|
        helper.date_picker(f, :date, **options)
      end
    end

    let(:options) { {} }

    let(:expected_classes) { %w[form-control string required datetimepicker] }
    let(:expected_type) { 'date' }
    let(:expected_data_options) { DateTimePickerHelper::DEFAULT_OPTIONS.merge(options) }

    context 'without any special config' do
      it 'renders all attributes correctly' do
        expect(date_picker_input_element.classes).to eq expected_classes
        expect(date_picker_input_element['type']).to eq expected_type
        expect(JSON.parse(date_picker_input_element['data-options'], symbolize_names: true)).to eq expected_data_options
      end
    end

    context 'without special config' do
      let(:options) { { dateFormat: 'customFormat' } }

      it 'renders all attributes correctly' do
        expect(date_picker_input_element.classes).to eq expected_classes
        expect(date_picker_input_element['type']).to eq expected_type
        expect(JSON.parse(date_picker_input_element['data-options'], symbolize_names: true)).to eq expected_data_options
      end
    end
  end

  describe '#range_date_picker' do
    subject(:range_date_picker_input_element) do
      Nokogiri::HTML(range_date_picker_html).at_xpath('//*[@id="object_range"]')
    end

    let(:range_date_picker_html) do
      helper.simple_form_for :object, url: root_path do |f|
        helper.range_date_picker(f, :range, **options)
      end
    end

    let(:options) { { mode: 'range' } }

    let(:expected_classes) { %w[form-control string required datetimepicker] }
    let(:expected_type) { 'date' }
    let(:expected_data_options) { DateTimePickerHelper::DEFAULT_OPTIONS.merge(options) }

    context 'without any special config' do
      it 'renders all attributes correctly' do
        expect(range_date_picker_input_element.classes).to eq expected_classes
        expect(range_date_picker_input_element['type']).to eq expected_type
        expect(
          JSON.parse(range_date_picker_input_element['data-options'], symbolize_names: true)
        ).to eq expected_data_options
      end
    end

    context 'without special config' do
      let(:options) { { mode: 'range', dateFormat: 'customFormat' } }

      it 'renders all attributes correctly' do
        expect(range_date_picker_input_element.classes).to eq expected_classes
        expect(range_date_picker_input_element['type']).to eq expected_type
        expect(
          JSON.parse(range_date_picker_input_element['data-options'], symbolize_names: true)
        ).to eq expected_data_options
      end
    end
  end
end
