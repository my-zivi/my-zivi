# frozen_string_literal: true

class HomeController < ApplicationController
  before_action -> { I18n.locale = :'de-CH' }

  def index; end

  def for_organizations; end

  def administration; end

  def recruiting; end

  def agb; end

  def privacy_policy; end

  def about_us; end
end
