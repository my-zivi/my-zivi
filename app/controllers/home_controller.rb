# frozen_string_literal: true

class HomeController < ApplicationController
  before_action -> { I18n.locale = :'de-CH' }

  before_action :load_faqs, only: :civil_servant_faq

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
end
