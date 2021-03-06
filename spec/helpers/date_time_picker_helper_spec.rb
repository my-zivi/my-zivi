# frozen_string_literal: true

require 'rails_helper'

def parse_options(date_picker_input_element)
  JSON.parse(date_picker_input_element['data-options'], symbolize_names: true)
end

RSpec.describe DateTimePickerHelper, type: :helper do
  describe '#date_picker' do
    subject(:date_picker_input_element) { Nokogiri::HTML(date_picker_html).at_xpath('//*[@id="object_date"]') }

    let(:date_picker_html) do
      helper.simple_form_for :object, url: root_path do |f|
        helper.date_picker(f, :date, value, required: required, **options)
      end
    end

    let(:options) { { defaultDate: I18n.l(value) } }
    let(:value) { Date.parse('2018-09-06') }
    let(:required) { false }

    let(:required_class) { required ? 'required' : 'optional' }
    let(:expected_classes) { %w[form-control string datetimepicker] + [required_class] }
    let(:expected_type) { 'date' }
    let(:expected_data_options) { DateTimePickerHelper::DEFAULT_OPTIONS.merge(locale: I18n.locale.to_s).merge(options) }

    context 'without any special config' do
      it 'renders all attributes correctly' do
        expect(date_picker_input_element.classes).to contain_exactly(*expected_classes)
        expect(date_picker_input_element['type']).to eq expected_type
        expect(date_picker_input_element['value']).to eq value.iso8601
        expect(date_picker_input_element['required']).not_to be_present
        expect(parse_options(date_picker_input_element)).to eq expected_data_options
      end
    end

    context 'with special config' do
      let(:options) { { dateFormat: 'customFormat', defaultDate: I18n.l(value) } }

      it 'renders all attributes correctly' do
        expect(date_picker_input_element.classes).to contain_exactly(*expected_classes)
        expect(date_picker_input_element['type']).to eq expected_type
        expect(date_picker_input_element['value']).to eq value.iso8601
        expect(date_picker_input_element['required']).not_to be_present
        expect(parse_options(date_picker_input_element)).to eq expected_data_options
      end
    end

    context 'with required true' do
      let(:required) { true }

      it 'renders all attributes correctly' do
        expect(date_picker_input_element.classes).to contain_exactly(*expected_classes)
        expect(date_picker_input_element['type']).to eq expected_type
        expect(date_picker_input_element['value']).to eq value.iso8601
        expect(date_picker_input_element['required']).to be_present
        expect(parse_options(date_picker_input_element)).to eq expected_data_options
      end
    end

    context 'with no value' do
      let(:value) { nil }
      let(:options) { {} }

      it 'renders all attributes correctly' do
        expect(date_picker_input_element['value']).to be_empty
        expect(parse_options(date_picker_input_element)).to eq expected_data_options
      end
    end
  end

  describe '#range_date_picker' do
    subject(:range_date_picker_input_element) do
      Nokogiri::HTML(range_date_picker_html).at_xpath('//*[@id="object_range"]')
    end

    let(:range_date_picker_html) do
      helper.simple_form_for :object, url: root_path do |f|
        helper.range_date_picker(f, :range, value, required: required, **options)
      end
    end

    let(:options) { { mode: 'range', defaultDate: %w[06.09.2020 10.09.2020] } }
    let(:value) { '06.09.2020 bis 10.09.2020' }
    let(:required) { false }

    let(:required_class) { required ? 'required' : 'optional' }
    let(:expected_classes) { %w[form-control string datetimepicker] + [required_class] }
    let(:expected_type) { 'date' }
    let(:expected_data_options) { DateTimePickerHelper::DEFAULT_OPTIONS.merge(locale: I18n.locale.to_s).merge(options) }
    let(:rendered_data_options) { parse_options(range_date_picker_input_element) }

    it 'renders all attributes correctly' do
      expect(range_date_picker_input_element.classes).to contain_exactly(*expected_classes)
      expect(range_date_picker_input_element['type']).to eq expected_type
      expect(range_date_picker_input_element['value']).to eq value
      expect(range_date_picker_input_element['readonly']).to eq 'readonly'
      expect(range_date_picker_input_element['required']).not_to be_present
      expect(rendered_data_options).to eq expected_data_options
    end

    context 'when value is nil' do
      let(:value) { nil }
      let(:options) { { mode: 'range' } }

      it 'renders all attributes correctly' do
        expect(range_date_picker_input_element['value']).to be_nil
        expect(rendered_data_options).to eq expected_data_options
      end
    end

    context 'with special config' do
      let(:options) { { mode: 'range', dateFormat: 'customFormat', defaultDate: %w[06.09.2020 10.09.2020] } }

      it 'renders all attributes correctly' do
        expect(range_date_picker_input_element.classes).to contain_exactly(*expected_classes)
        expect(range_date_picker_input_element['type']).to eq expected_type
        expect(range_date_picker_input_element['required']).not_to be_present
        expect(rendered_data_options).to eq expected_data_options
      end
    end

    context 'with required true' do
      let(:required) { true }

      it 'renders all attributes correctly' do
        expect(range_date_picker_input_element.classes).to contain_exactly(*expected_classes)
        expect(range_date_picker_input_element['type']).to eq expected_type
        expect(range_date_picker_input_element['required']).to be_present
        expect(rendered_data_options).to eq expected_data_options
      end
    end
  end

  describe '#parse_range_date' do
    subject(:date_picker_input_element) { helper.parse_range_date(range_value) }

    let(:range_value) { "#{range_beginning} #{date_splitter} #{range_ending}}" }
    let(:range_beginning) { '' }
    let(:range_ending) { '' }
    let(:date_splitter) { '' }

    context 'when input is empty' do
      it { is_expected.to be_nil }
    end

    context 'when input is invalid' do
      let(:range_beginning) { Date.parse('01.08.2020') }

      it { is_expected.to be_nil }
    end

    context 'when locale is :de-CH' do
      around { |spec| I18n.with_locale(:'de-CH') { spec.run } }

      let(:date_splitter) { ' bis ' }
      let(:expected_range) { range_beginning..range_ending }

      context 'when the date range is one month' do
        context 'when it is perfectly one month' do
          let(:range_beginning) { Date.parse('01.08.2020') }
          let(:range_ending) { Date.parse('31.08.2020') }

          it { is_expected.to eq expected_range }
        end

        context 'when it is part of two months' do
          let(:range_beginning) { Date.parse('19.08.2020') }
          let(:range_ending) { Date.parse('12.09.2020') }

          it { is_expected.to eq expected_range }
        end
      end

      context 'when the date range is one week' do
        let(:range_beginning) { Date.parse('03.08.2020') }
        let(:range_ending) { Date.parse('09.08.2020') }

        it { is_expected.to eq expected_range }
      end

      context 'when the date range is one day' do
        let(:range_beginning) { Date.parse('01.08.2020') }
        let(:range_ending) { Date.parse('01.08.2020') }

        it { is_expected.to eq expected_range }
      end
    end

    context 'when locale is :fr-CH' do
      around { |spec| I18n.with_locale(:'fr-CH') { spec.run } }

      let(:date_splitter) { ' au ' }
      let(:expected_range) { range_beginning..range_ending }

      context 'when the date range is one month' do
        context 'when it is perfectly one month' do
          let(:range_beginning) { Date.parse('01.08.2020') }
          let(:range_ending) { Date.parse('31.08.2020') }

          it { is_expected.to eq expected_range }
        end

        context 'when it is part of two months' do
          let(:range_beginning) { Date.parse('19.08.2020') }
          let(:range_ending) { Date.parse('12.09.2020') }

          it { is_expected.to eq expected_range }
        end
      end

      context 'when the date range is one week' do
        let(:range_beginning) { Date.parse('03.08.2020') }
        let(:range_ending) { Date.parse('09.08.2020') }

        it { is_expected.to eq expected_range }
      end

      context 'when the date range is one day' do
        let(:range_beginning) { Date.parse('01.08.2020') }
        let(:range_ending) { Date.parse('01.08.2020') }

        it { is_expected.to eq expected_range }
      end
    end
  end
end
