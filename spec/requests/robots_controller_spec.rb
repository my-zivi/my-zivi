# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RobotsController do
  describe '#robots' do
    subject { response }

    let(:perform_request) { get robots_path(format: :text) }
    let(:robots_allowed) { 'true' }
    let(:envs) { { ROBOTS_ALLOWED: robots_allowed } }

    around do |spec|
      ClimateControl.modify(envs) do
        spec.run
      end
    end

    before { perform_request }

    it { is_expected.to render_template 'robots/allow' }

    context 'when robots are not allowed' do
      let(:robots_allowed) { 'false' }

      it { is_expected.to render_template 'robots/disallow' }
    end

    context 'when a sitemap is specified' do
      subject { response.body }

      let(:envs) do
        {
          ROBOTS_ALLOWED: robots_allowed,
          SITEMAP_ENABLED: 'true',
          SITEMAP_PUBLIC_URL: 'http://example.com/sitemap.xml.gz'
        }
      end

      it { is_expected.to include 'Sitemap: http://example.com/sitemap.xml.gz' }

      context 'when SITEMAP_ENABLED is set to false' do
        let(:envs) do
          {
            ROBOTS_ALLOWED: robots_allowed,
            SITEMAP_ENABLED: 'false',
            SITEMAP_PUBLIC_URL: 'http://example.com/sitemap.xml.gz'
          }
        end

        it { is_expected.not_to include 'Sitemap: http://example.com/sitemap.xml.gz' }
      end
    end
  end
end
