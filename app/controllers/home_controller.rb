# frozen_string_literal: true

class HomeController < ApplicationController
  before_action -> { I18n.locale = :'de-CH' }

  before_action :load_faqs, only: :civil_servant_faq
  before_action :load_structured_faqs, only: :civil_servant_faq

  def index; end

  def for_organizations; end

  def for_civil_servants; end

  def administration; end

  def recruiting; end

  def civil_servant_faq; end

  def agb; end

  def privacy_policy; end

  def about_us; end

  private

  def load_faqs
    @faqs = Faq.all
  end
  
  # :reek:FeatureEnvy
  def load_structured_faqs
    @faqs_structured = {
      '@context': 'https://schema.org',
      '@type': 'FAQPage',
      mainEntity: Faq.all.map do |faq|
        {
          '@type': 'Question',
          name: faq.question,
          acceptedAnswer: { '@type': 'Answer', text: faq.answer }
        }
      end
    }
  end
end
