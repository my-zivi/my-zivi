# frozen_string_literal: true

module RespondWithPdfConcern
  def respond_with_pdf(pdf_file, pdf_title = nil)
    send_data(pdf_file, filename: pdf_title, type: 'application/pdf', disposition: 'inline')
  end
end
