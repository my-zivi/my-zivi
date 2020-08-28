# frozen_string_literal: true

module Organizations
  class PhoneListController < BaseController
    include RespondWithPdfConcern

    def index
      set_service_specifications
      load_filters

      respond_to do |format|
        format.html
        format.pdf(&method(:respond_to_pdf))
      end
    end

    private

    def respond_to_pdf
      respond_with_pdf(
        Pdfs::PhoneListService.new(@service_specifications, @filters[:beginning], @filters[:ending]).render,
        I18n.t('pdfs.phone_list.file_name', today: I18n.l(Time.zone.today))
      )
    end

    def set_service_specifications
      @service_specifications = Service
                                .accessible_by(current_ability)
                                .active
                                .includes(:service_specification, civil_servant: %i[address user])
                                .order(ending: :desc)
                                .distinct(:civil_servant)
                                .group_by { |service| service.service_specification.name }
    end

    def load_filters
      @filters = {
        beginning: params.dig(:filters, :beginning),
        ending: params.dig(:filters, :ending)
      }
    end
  end
end
