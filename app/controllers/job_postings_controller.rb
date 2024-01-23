# frozen_string_literal: true

class JobPostingsController < ApplicationController
  before_action -> { I18n.locale = :'de-CH' }
  before_action :load_job_posting, only: [:show, :widget]

  def index; end

  def show
    raise ActiveRecord::RecordNotFound unless can?(:read, @job_posting)
  end

  def widget
    response.headers.delete 'X-Frame-Options'
    raise ActiveRecord::RecordNotFound unless can?(:read, @job_posting) && can?(:read_widget, @job_posting)

    render layout: 'widget'
  end

  private

  def load_job_posting
    @job_posting = JobPosting.eager_load(:workshops, :available_service_periods)
                             .with_rich_text_description_and_embeds
                             .with_rich_text_required_skills_and_embeds
                             .with_rich_text_preferred_skills_and_embeds
                             .find_by(slug: slug_params)
  end

  def slug_params
    params.require(:slug)
  end
end
