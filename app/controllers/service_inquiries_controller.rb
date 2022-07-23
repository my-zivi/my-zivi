# frozen_string_literal: true

class ServiceInquiriesController < ApplicationController
  load_and_authorize_resource

  before_action :authorize_job_posting_association!

  def new; end

  def create
    if @service_inquiry.save
      render :create
    else
      render :new
    end
  end

  def service_inquiry_params
    params.require(:service_inquiry).permit(:name, :email, :phone, :service_beginning, :agreement,
                                            :service_duration, :message, :job_posting_id)
  end

  private

  def authorize_job_posting_association!
    return if @service_inquiry.job_posting.present? && can?(:read, @service_inquiry.job_posting)

    raise ActiveRecord::RecordNotFound
  end
end
