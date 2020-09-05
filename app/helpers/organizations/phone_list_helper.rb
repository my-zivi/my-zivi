# frozen_string_literal: true

module Organizations
  module PhoneListHelper
    def phone_list_pdf_link(filters, &block)
      link_to(pdf_url(filters), target: '_blank', rel: 'noopener', class: 'btn btn-falcon-default btn-sm', &block)
    end

    private

    def pdf_url(filters)
      {
        format: 'pdf',
        name: t('pdfs.phone_list.file_name', today: l(Time.zone.today)).parameterize,
        params: pdf_url_params(filters[:beginning], filters[:ending])
      }
    end

    def pdf_url_params(beginning, ending)
      return {} if beginning.nil? || ending.nil?

      { filters: { beginning: beginning, ending: ending } }
    end
  end
end
