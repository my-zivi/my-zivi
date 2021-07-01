# frozen_string_literal: true

module Organizations
  class JobPostingsController < BaseController
    load_and_authorize_resource
    skip_authorize_resource only: :index

    def index
      @job_postings = @job_postings.accessible_by(current_ability, :edit)
    end

    def edit; end

    def update
      if @job_posting.update(job_posting_params)
        redirect_to edit_organizations_job_posting_path(@job_posting), notice: t('.successful_update')
      else
        flash[:error] = t('.erroneous_update')
        render :edit
      end
    end

    private

    def job_posting_params
      params.require(:job_posting).permit(
        :title, :description, :required_skills, :preferred, :category,
        :published, :preferred_skills, :priority_program, :language,
        :identification_number, :sub_category, :canton,
        :brief_description, :minimum_service_months
      )
    end
  end
end
