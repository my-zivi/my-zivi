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
      @service_specifications = filtered_services
                                .includes(:service_specification, civil_servant: %i[address user])
                                .order(ending: :desc)
                                .group_by { |service| service.service_specification.name }
                                .transform_values do |services|
                                  services.uniq(&:civil_servant)
                                end
    end

    def filtered_services
      beginning = @filters[:beginning]
      ending =  @filters[:ending]

      if beginning.present? && ending.present?
        Service
          .accessible_by(current_ability)
          .overlapping_date_range(beginning, ending)
      else
        Service
          .accessible_by(current_ability)
          .active
      end
    end

    def load_filters
      @filters = load_parsed_range_filter.present? ? load_date_filters_from_range : load_date_filters_directly
    end

    def load_parsed_range_filter
      parse_range_date(params.dig(:filters, :range))
    end

    def load_date_filters_from_range
      {
        range: params.dig(:filters, :range),
        beginning: load_parsed_range_filter.begin,
        ending: load_parsed_range_filter.end
      }
    end

    def load_date_filters_directly
      params_beginning = params.dig(:filters, :beginning)
      params_ending = params.dig(:filters, :ending)

      {
        beginning: params_beginning.nil? ? nil : Date.parse(params_beginning),
        ending: params_ending.nil? ? nil : Date.parse(params_ending)
      }
    end
  end
end
