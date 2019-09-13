# frozen_string_literal: true

module V1
  class PaymentsController < ApplicationController
    include V1::Concerns::AdminAuthorizable
    include V1::Concerns::ParamsAuthenticatable

    before_action :authenticate_from_params!, if: -> { request.format.xml? }
    before_action :authenticate_user!, unless: -> { request.format.xml? }
    before_action :authorize_admin!

    def show
      @payment = Payment.find(payment_timestamp_param)

      respond_to do |format|
        format.json
        format.xml do
          send_data generate_pain, disposition: 'attachment',
                                   filename: I18n.t('payment.pain_filename',
                                                    from_date: I18n.l(@payment.payment_timestamp, format: '%d.%m.%Y'))
        end
      end
    end

    def index
      @payments = Payment.all(payments_list_filter)
    end

    def create
      expense_sheets = ExpenseSheet.includes(:user).ready_for_payment.all
      @payment = Payment.new expense_sheets: expense_sheets

      raise ValidationError, @payment.errors unless @payment.save

      render :show, state: :created
    end

    def destroy
      @payment = Payment.find(payment_timestamp_param)

      raise ValidationError, @payment.errors unless @payment.cancel

      render :show
    end

    def confirm
      @payment = Payment.find(payment_timestamp_param)

      raise ValidationError, @payment.errors unless @payment.confirm

      render :show
    end

    def self.filter_at_year(year_delta)
      lower_boundary = Time.zone.now - year_delta.years
      upper_boundary = lower_boundary + 1.year

      [
        ExpenseSheet.arel_table[:payment_timestamp].gteq(lower_boundary),
        ExpenseSheet.arel_table[:payment_timestamp].lteq(upper_boundary)
      ]
    end

    private

    def payments_list_filter
      return if filter_param.blank?

      year_delta_filter
    end

    def year_delta_filter
      year_delta = filter_param[:year_delta].to_i

      return [] unless year_delta.positive?

      PaymentsController.filter_at_year(year_delta)
    end

    def payment_timestamp_param
      Time.zone.at(params[:payment_timestamp].to_i)
    end

    def generate_pain
      PainGenerationService.new(@payment.expense_sheets).generate_pain.to_xml('pain.001.001.03.ch.02')
    end

    def filter_param
      params.permit(filter: [:year_delta])[:filter]
    end
  end
end
