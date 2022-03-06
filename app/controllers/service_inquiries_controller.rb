# frozen_string_literal: true

class ServiceInquiriesController < ApplicationController
  load_and_authorize_resource except: :new

  def new
    job_posting = JobPosting.find(service_inquiry_params[:job_posting_id])
    raise ActiveRecord::RecordNotFound unless can?(:read, job_posting)

    @service_inquiry = ServiceInquiry.new(job_posting: job_posting)
  end

  def create
    raise ActiveRecord::RecordNotFound unless can?(:read, @service_inquiry.job_posting)

    if @service_inquiry.save
      render :create
    else
      render :new
    end
  end

  def service_inquiry_params
    params.require(:service_inquiry).permit(:name, :email, :phone, :service_beginning,
                                            :service_ending, :message, :job_posting_id)
  end
end
