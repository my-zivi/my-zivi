# frozen_string_literal: true

class HomeController < ApplicationController
  before_action -> { I18n.locale = :'de-CH' }

  def index; end

  def for_organizations; end

  def for_civil_servants; end

  def administration; end

  def recruiting; end

  def civil_servant_faq
    @faqs = Faq.all
  end

  def agb; end

  def privacy_policy; end

  def about_us; end

  def pricing; end
end
