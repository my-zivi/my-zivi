# frozen_string_literal: true

module Organizations
  class PhoneListController < BaseController
    include RespondWithPdfConcern
    include DateTimePickerHelper

    def index
      load_filters
      set_service_specifications

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
      @service_specifications = filtered_service_specifications
                                .includes(:service_specification, civil_servant: %i[address user])
                                .order(ending: :desc)
                                .distinct(:civil_servant)
                                .group_by { |service| service.service_specification.name }
    end

    def filtered_service_specifications
      if @filters[:range].present?
        Service
          .accessible_by(current_ability)
          .overlapping_date_range(@filters[:parsed_range].begin, @filters[:parsed_range].end)
      else
        Service
          .accessible_by(current_ability)
          .active
      end
    end

    def load_filters
      @filters = {
        range: params.dig('/organizations/phone_list', :range),
        parsed_range: parse_range_date(params.dig('/organizations/phone_list', :range)),
        beginning: params.dig(:filters, :beginning),
        ending: params.dig(:filters, :ending)
      }
    end
  end
end
