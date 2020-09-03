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

    context 'when locale is :de' do
      around { |spec| I18n.with_locale(:de) { spec.run } }

      let(:date_splitter) { 'bis' }
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

    context 'when locale is :fr' do
      around { |spec| I18n.with_locale(:fr) { spec.run } }

      let(:date_splitter) { 'au' }
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
