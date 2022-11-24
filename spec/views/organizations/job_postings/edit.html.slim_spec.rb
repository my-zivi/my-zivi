# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organizations/job_postings/edit', type: :view do
  subject { rendered }

  let(:job_posting) { create(:job_posting) }
  let(:expected_text_fields) { %w[title identification_number brief_description] }
  let(:expected_number_fields) { %w[minimum_service_months weekly_work_time] }
  let(:expected_dropdown_fields) do
    %w[language canton category sub_category fixed_work_time good_reputation e_government work_on_weekend
       work_night_shift accommodation_provided food_provided]
  end

  before do
    assign(:job_posting, job_posting)
    render
  end

  it 'contains all the form fields' do
    assert_select 'form[action=?][method=?]', organizations_job_posting_path(job_posting), 'post' do
      expected_text_fields.each { |field| assert_select 'input[name=?]', "job_posting[#{field}]" }
      expected_dropdown_fields.each { |field| assert_select 'select[name=?]', "job_posting[#{field}]" }
      expected_number_fields.each { |field| assert_select 'input[name=?][type=?]', "job_posting[#{field}]", 'number' }
    end
  end
end
