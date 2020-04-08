# frozen_string_literal: true

module V1
  class PhoneListController < FileController
    include V1::Concerns::AdminAuthorizable

    before_action :authorize_admin!
    before_action :load_specifications, only: :show

    def show
      respond_to do |format|
        format.pdf do
          pdf = Pdfs::PhoneListService.new(@specifications, sanitized_filters)

          send_data pdf.render,
                    filename: I18n.t('pdfs.phone_list.filename', today: I18n.l(Time.zone.today)),
                    type: 'application/pdf',
                    disposition: 'inline'
        end
      end
    end

    private

    def load_specifications
      @specifications = Service.overlapping_date_range(sanitized_filters.beginning, sanitized_filters.ending)
                               .includes(:service_specification, :civil_servant)
                               .order('service_specification_id')
                               .group_by { |service| service.service_specification.name }
    end

    # :reek:FeatureEnvy
    def filter_params
      params.require(:phone_list).permit(:beginning, :ending).tap do |phone_list_params|
        phone_list_params.require(:beginning)
        phone_list_params.require(:ending)
      end
    end

    def sanitized_filters
      @sanitized_filters ||= OpenStruct.new(
        beginning: Date.parse(filter_params[:beginning]),
        ending: Date.parse(filter_params[:ending])
      )
    end
  end
end
