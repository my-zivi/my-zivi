# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobPostingAttributesFooterComponent, type: :component do
  subject(:rendered) { render_inline(described_class.new(job_posting: job_posting)) }

  let(:job_posting) { build(:job_posting) }

  it 'renders all the attributes' do
    expect(rendered.css('.job-posting-attribute').count).to eq(described_class::ATTRIBUTES.count)
  end

  context 'when some attributes are not present' do
    let(:job_posting) { build(:job_posting, work_night_shift: nil) }

    it 'renders only the present attributes' do
      expect(rendered.css('.job-posting-attribute').count).to eq(described_class::ATTRIBUTES.count - 1)
    end
  end

  context 'when all attributes are not present' do
    let(:job_posting) do
      build(:job_posting, weekly_work_time: nil, fixed_work_time: nil, good_reputation: nil, e_government: nil,
                          work_on_weekend: nil, work_night_shift: nil, accommodation_provided: nil, food_provided: nil)
    end

    it 'renders no attributes' do
      expect(rendered.css('.job-posting-attribute').count).to(eq(0))
    end
  end
end
