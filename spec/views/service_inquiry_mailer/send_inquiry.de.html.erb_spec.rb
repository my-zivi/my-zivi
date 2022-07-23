# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'service_inquiry_mailer/send_inquiry.html.erb' do
  let(:service_inquiry) { build(:service_inquiry, phone: nil, email: 'mail@example.com') }
  let(:job_posting) { create(:job_posting) }

  before do
    assign(:service_inquiry, service_inquiry)
    assign(:job_posting, job_posting)
    render
  end

  it 'renders email' do
    expect(rendered).to include service_inquiry.email
  end

  context 'with phone number given' do
    let(:service_inquiry) { build(:service_inquiry, phone: '0441234545') }

    it 'renders phone number' do
      expect(rendered).to include service_inquiry.phone
    end
  end
end
