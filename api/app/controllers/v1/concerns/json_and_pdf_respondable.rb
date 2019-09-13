# frozen_string_literal: true

module V1
  module Concerns
    module JsonAndPdfRespondable
      def respond_to_json_and_pdf(pdf, filename, *args)
        respond_to do |format|
          format.json
          format.pdf do
            send_data pdf.new(*args).render,
                      filename: filename,
                      type: 'application/pdf',
                      disposition: 'inline'
          end
        end
      end
    end
  end
end
