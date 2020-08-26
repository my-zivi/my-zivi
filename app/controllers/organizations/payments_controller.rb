# frozen_string_literal: true

module Organizations
  class PaymentsController < BaseController
    load_and_authorize_resource

    def index
      @payments = @payments.order(created_at: :desc, state: :asc)
    end

    def show
      respond_to do |format|
        format.html
        format.xml(&method(:respond_to_xml))
      end
    end

    def update
      process_paid_state_update
      # TODO: Handle also other updates, if needed?

      redirect_back fallback_location: organizations_payments_path
    end

    def destroy
      if @payment.destroy
        flash[:success] = t('.successful_destroy')
      else
        flash[:error] = t('.erroneous_destroy')
      end

      redirect_back fallback_location: organizations_payments_path
    end

    private

    def process_paid_state_update
      if payment_params[:state] == 'paid' && !@payment.readonly? && @payment.paid_out!
        flash[:success] = I18n.t('organizations.payments.update.successful_update')
      else
        flash[:error] = I18n.t('organizations.payments.update.erroneous_update')
      end
    end

    def respond_to_xml
      send_data(
        pain_content,
        disposition: 'attachment',
        filename: I18n.t('organizations.payments.pain_file_name', date: I18n.l(@payment.created_at.to_date))
      )
    end

    def pain_content
      PainGenerationService.call(@payment).to_xml('pain.001.001.03.ch.02')
    end

    def payment_params
      params.require(:payment).permit(:state)
    end
  end
end
