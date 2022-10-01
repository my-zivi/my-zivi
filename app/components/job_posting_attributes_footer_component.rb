# frozen_string_literal: true

class JobPostingAttributesFooterComponent < ViewComponent::Base
  extend ActiveSupport::NumberHelper

  ATTRIBUTES = %i[weekly_work_time fixed_work_time good_reputation e_government
                  work_on_weekend work_night_shift accommodation_provided food_provided].freeze

  FORMATS = {
    weekly_work_time: lambda do |job_posting|
      I18n.t('job_postings.attributes.weekly_work_time.body',
             weekly_work_time: number_to_rounded(job_posting.weekly_work_time, strip_insignificant_zeros: true))
    end
  }.freeze

  def initialize(job_posting:)
    @job_posting = job_posting
  end

  def attributes
    @attributes ||= @job_posting.attributes.symbolize_keys.slice(*ATTRIBUTES).compact.map do |key, value|
      {
        body: format_body(key, value),
        title: I18n.t("job_postings.attributes.#{key}.title")
      }
    end
  end

  def format_body(key, value)
    if FORMATS.key?(key.to_sym)
      FORMATS[key.to_sym].call(@job_posting)
    else
      I18n.t(value, scope: "job_postings.attributes.#{key}.body")
    end
  end
end
