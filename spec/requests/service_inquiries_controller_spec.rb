# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ServiceInquiriesController do
  describe '#new' do
    subject { response }

    let(:job_posting) { create(:job_posting) }

    context 'when a valid job posting id is passed' do
      let(:perform_request) { get new_service_inquiry_path(service_inquiry: { job_posting_id: job_posting.id }) }

      before { perform_request }

      it { is_expected.to render_template 'service_inquiries/new' }
    end

    context 'when no job posting id is passed' do
      let(:perform_request) { get new_service_inquiry_path(service_inquiry: { job_posting_id: nil }) }

      it 'raises a not found error' do
        expect { perform_request }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context 'when no job posting id parameter is passed' do
      let(:perform_request) { get new_service_inquiry_path }

      it 'raises a parameter missing error' do
        expect { perform_request }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context 'when the passed job posting id is not readable' do
      let(:perform_request) { get new_service_inquiry_path(service_inquiry: { job_posting_id: job_posting.id }) }
      let(:job_posting) { create(:job_posting, published: false) }

      it 'raises a not found error' do
        expect { perform_request }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe '#create' do
    subject { response }

    let(:job_posting) { create(:job_posting) }
    let(:perform_request) { post service_inquiries_path(service_inquiry: service_inquiry_params) }
    let(:service_inquiry_params) do
      attributes_for(:service_inquiry, job_posting: job_posting)
        .except(:job_posting)
        .merge(job_posting_id: job_posting.id)
    end
    let(:created_service_inquiry) { ServiceInquiry.order(created_at: :desc).first }

    around do |spec|
      freeze_time do
        spec.run
      end
    end

    it 'creates a new inquiry' do
      expect { perform_request }.to change(ServiceInquiry, :count)
      attributes = created_service_inquiry.attributes.symbolize_keys.without(:id, :created_at, :updated_at, :agreement)
      expect(attributes).to eq(service_inquiry_params)
      expect(response).to render_template 'service_inquiries/create'
    end

    context 'when there are errors in the form' do
      let(:service_inquiry_params) { { name: 'Hey', job_posting_id: job_posting.id } }

      it 'does not create a new inquiry' do
        expect { perform_request }.not_to change(ServiceInquiry, :count)
        expect(response).to render_template 'service_inquiries/new'
      end
    end

    context 'when no job posting is passed' do
      let(:service_inquiry_params) { { job_posting_id: -4 } }

      it 'raises a not found error' do
        expect { perform_request }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context 'when no job posting id parameter is passed' do
      let(:service_inquiry_params) { {} }

      it 'raises a parameter missing error' do
        expect { perform_request }.to raise_error ActionController::ParameterMissing
      end
    end

    context 'when the job posting is not public' do
      let(:job_posting) { create(:job_posting, published: false) }

      it 'raises a not found error' do
        expect { perform_request }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
