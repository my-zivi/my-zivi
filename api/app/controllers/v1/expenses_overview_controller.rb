# frozen_string_literal: true

module V1
  class ExpensesOverviewController < FileController
    include V1::Concerns::AdminAuthorizable
    include Pdfs::ExpenseSheet

    before_action :authenticate_user!, unless: -> { request.format.pdf? }
    before_action :authenticate_from_params!, if: -> { request.format.pdf? }
    before_action :load_specifications, only: :show
    before_action :authorize_admin!

    def show
      respond_to do |format|
        format.pdf do
          pdf = Pdfs::ExpensesOverviewService.new(@specifications, sanitized_filters)

          send_data pdf.render,
                    filename: I18n.t('pdfs.expenses_overview.filename', today: I18n.l(Time.zone.today)),
                    type: 'application/pdf',
                    disposition: 'inline'
        end
      end
    end

    private

    def load_specifications
      @specifications = ExpenseSheet.overlapping_date_range(sanitized_filters.beginning, sanitized_filters.ending)
                                    .includes(:user)
                                    .order('users.last_name')
                                    .group_by { |expense_sheet, _user| expense_sheet.user_id }
    end

    # :reek:FeatureEnvy
    def filter_params
      params.require(:expenses_overview).permit(:beginning, :ending).tap do |expenses_overview_params|
        expenses_overview_params.require(:beginning)
        expenses_overview_params.require(:ending)
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
