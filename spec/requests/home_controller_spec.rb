# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController, type: :request do
  shared_examples_for 'can access home page' do
    it 'returns http success' do
      get path
      expect(response).to have_http_status(:success)
      expect(response.body).not_to be_empty
    end
  end

  describe '#index' do
    around do |spec|
      I18n.locale.yield_self do |default_locale|
        spec.run
        I18n.locale = default_locale
      end
    end

    it_behaves_like 'can access home page' do
      let(:path) { root_path }
    end

    it 'uses german locale' do
      I18n.locale = :'fr-CH'
      expect { get path }.to(change(I18n, :locale).to(:'de-CH'))
    end
  end

  %w[administration recruiting agb privacy_policy about_us for_organizations].each do |route|
    describe "##{route}" do
      it_behaves_like 'can access home page' do
        let(:path) { public_send(:"#{route}_path") }
      end
    end
  end

  describe 'zivi-faq' do
    let(:perform_request) { get civil_servant_faq_path }
    let!(:zivi_faq) { create(:faq) }

    it 'renders the faq' do
      perform_request
      expect(response).to be_successful
      expect(response.body).to include(
        zivi_faq.question,
        zivi_faq.answer
      )
    end

    it_behaves_like 'can access home page' do
      let(:path) { public_send(:civil_servant_faq_path) }
    end
  end
end
