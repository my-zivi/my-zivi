# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :request do
  describe '#set_locale' do
    subject(:actual_locale) { I18n.locale }

    context 'with known locales' do
      it 'sets fr locale' do
        get v1_service_specifications_path, params: { locale: :fr }
        expect(actual_locale).to eq :fr
      end

      it 'sets de locale' do
        get v1_service_specifications_path, params: { locale: :de }
        expect(actual_locale).to eq :de
      end

      it 'sets en locale' do
        get v1_service_specifications_path, params: { locale: :en }
        expect(actual_locale).to eq :en
      end
    end

    context 'with an unknown locale' do
      before { get v1_service_specifications_path, params: { locale: :ru } }

      it 'sets the default locale' do
        expect(actual_locale).to eq I18n.default_locale
      end
    end
  end
end
