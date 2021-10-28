# frozen_string_literal: true

module Organizations
  class PaymentsController < BaseController
    PAIN_SCHEME = 'pain.001.001.03.ch.02'

    before_action :load_accessible_expense_sheets, only: :new

    load_and_authorize_resource
    breadcrumb 'organizations.payments.index', :organizations_payments_path

    def index
      @payments = @payments.order(state: :asc, created_at: :desc)
    end

    def new
      breadcrumb 'organizations.payments.new', :new_organizations_payment_path
    end

    def create
      breadcrumb 'organizations.payments.new', :new_organizations_payment_path
      @payment.amount = @payment.expense_sheets.sum(&:amount)

      if @payment.save
        flash.now[:success] = t('.successful_create')
        redirect_to organizations_payment_path(@payment)
      else
        load_accessible_expense_sheets
        flash.now[:error] = t('.erroneous_create')
        render :new
      end
    end

    def show
      breadcrumb I18n.t('loaf.breadcrumbs.organizations.payments.show', date: l(@payment.created_at.to_date)),
                 organizations_payments_path(@payment)
      respond_to do |format|
        format.html
        format.xml { respond_to_xml }
      end
    end

    def update
      process_paid_state_update
      # TODO: Handle also other updates, if needed?

      redirect_back fallback_location: organizations_payments_path
    end

    def destroy
      if @payment.destroy
        flash.now[:success] = t('.successful_destroy')
      else
        flash.now[:error] = t('.erroneous_destroy')
      end

      redirect_back fallback_location: organizations_payments_path
    end

    private

    def process_paid_state_update
      if payment_params[:state] == 'paid' && !@payment.readonly? && @payment.paid_out!
        flash.now[:success] = I18n.t('organizations.payments.update.successful_update')
      else
        flash.now[:error] = I18n.t('organizations.payments.update.erroneous_update')
      end
    end

    def respond_to_xml
      payment_data = PainGenerationService.call(@payment).to_xml(PAIN_SCHEME)

      send_data(
        payment_data,
        disposition: 'attachment',
        filename: I18n.t('organizations.payments.pain_file_name', date: I18n.l(@payment.created_at.to_date))
      )
    rescue StandardError => e
      track_payment_generation_error(e)
      raise e
    end

    def track_payment_generation_error(exception)
      return unless defined? Sentry

      Sentry.capture_exception(exception, extra: {
                                 action: 'SEPA generation',
                                 payment_id: @payment.id
                               })
    end

    def load_accessible_expense_sheets
      @accessible_expense_sheets = ExpenseSheet
                                   .accessible_by(current_ability)
                                   .editable
                                   .where(payment: nil)
                                   .includes(:civil_servant)
    end

    def create_params
      params.require(:payment).permit(expense_sheet_ids: [])
    end

    def payment_params
      params.require(:payment).permit(:state)
    end
  end
end
