# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'job_postings/_structured_data.html.erb', type: :view do
  let(:job_posting) { create(:job_posting) }

  before do
    render(partial: 'job_postings/structured_data', locals: { job_posting: job_posting })
  end

  it 'renders the structured data' do
    content = rendered.match(%r{<script type="application/ld\+json">(.*)</script>}m)[1]&.strip
    parsed = JSON.parse(content)
    expect(parsed).to include(
      '@context' => 'https://schema.org/',
      '@type' => 'JobPosting',
      'title' => be_a(String)
    )
  end
end
