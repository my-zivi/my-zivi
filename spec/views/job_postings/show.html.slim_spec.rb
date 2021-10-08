# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'job_postings/show.html.slim', type: :view do
  subject { rendered }

  let(:job_posting) { build(:job_posting) }

  before do
    assign(:job_posting, job_posting)
    allow(view).to receive(:current_user).and_return(build(:user))
    render
  end

  it 'renders the job posting without publication notice' do
    expect(rendered).to include job_posting.title
    expect(rendered).not_to include I18n.t('job_postings.show.unpublished_alert.title')
  end

  context 'when job posting has not been published yet' do
    let(:job_posting) { build(:job_posting, published: false, slug: 'my-slug') }

    it 'renders the publication notice' do
      expect(rendered).to include I18n.t('job_postings.show.unpublished_alert.title')
    end
  end

  context 'when the job posting has an address' do
    let(:job_posting) { build(:job_posting, :with_address) }

    it 'renders the map box' do
      expect(rendered).to have_selector('#map-embed')
    end

    context 'when address has no coordinates' do
      let(:job_posting) { build(:job_posting, address: build(:address)) }

      it 'does not render the map box' do
        expect(rendered).not_to have_selector('#map-embed')
      end
    end
  end
end
