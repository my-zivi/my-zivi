# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/service_inquiry
class ServiceInquiryPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/service_inquiry/send_inquiry
  def send_inquiry
    ServiceInquiryMailer.with(service_inquiry_id: service_inquiry.id).send_inquiry
  end

  def send_confirmation
    ServiceInquiryMailer.with(service_inquiry_id: service_inquiry.id).send_confirmation
  end

  private

  def service_inquiry
    ServiceInquiry.find_or_create_by(email: 'peter.parker@example.com') do |inquiry|
      inquiry.assign_attributes({
                                  name: 'Peter Parker',
                                  phone: '044 123 34 45',
                                  service_beginning: 'Mitte Mai',
                                  service_duration: '3 Monate',
                                  message: 'Hallo! Hier ist Peter!',
                                  job_posting: JobPosting.last
                                })
    end
  end
end
