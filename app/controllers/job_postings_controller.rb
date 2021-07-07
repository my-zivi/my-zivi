# frozen_string_literal: true

class JobPostingsController < ApplicationController
  before_action -> { I18n.locale = :'de-CH' }

  def index; end

  def show
    @job_posting = JobPosting.eager_load(:workshops, :available_service_periods).find_by(slug: params[:slug])
    raise ActiveRecord::RecordNotFound unless can?(:read, @job_posting)
  end
end
