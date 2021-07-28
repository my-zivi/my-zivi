# frozen_string_literal: true

class JobPostingsController < ApplicationController
  before_action -> { I18n.locale = :'de-CH' }

  def index; end

  def show
    @job_posting = JobPosting.eager_load(:workshops, :available_service_periods)
                             .with_rich_text_description_and_embeds
                             .with_rich_text_required_skills_and_embeds
                             .with_rich_text_preferred_skills_and_embeds
                             .find_by(slug: slug_params)
    raise ActiveRecord::RecordNotFound unless can?(:read, @job_posting)
  end

  private

  def slug_params
    params.require(:slug)
  end
end
