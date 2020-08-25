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
      if !@payment.readonly? && @payment.update(payment_params)
        flash[:success] = 'Hat gefunktioniert'
      else
        flash[:error] = 'Hat nicht gefuntztz'
      end

      redirect_back fallback_location: organizations_payments_path
    end

    def destroy; end

    private

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
