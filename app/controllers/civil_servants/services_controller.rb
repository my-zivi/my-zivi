# frozen_string_literal: true

module CivilServants
  class ServicesController < BaseController
    include RespondWithPdfConcern

    load_and_authorize_resource

    def index
      load_filters
      @services = filtered_service.chronologically.includes(:service_specification, :organization)
    end

    def show
      respond_to do |format|
        format.html
        format.pdf { render_pdf }
      end
    end

    private

    def filtered_service
      return @services.definitive if @filters[:show_all]

      @services.definitive.where('ending >= ?', Time.zone.today)
    end

    def load_filters
      @filters = {
        show_all: params.dig(:filters, :show_all) == 'true'
      }
    end

    def render_pdf
      respond_with_pdf Pdfs::ServiceAgreement::FormFiller.render(
        Pdfs::ServiceAgreement::DataProvider.evaluate_data_hash(
          Pdfs::ServiceAgreement::GermanFormFields::SERVICE_AGREEMENT_FIELDS,
          service: @service
        ),
        Rails.root.join('lib/assets/pdfs/german_service_agreement_form.pdf').to_s
      ), I18n.t('pdfs.service_agreement.file_name',
                name: @service.civil_servant.full_name,
                beginning: @service.beginning,
                ending: @service.ending)
    end
  end
end
