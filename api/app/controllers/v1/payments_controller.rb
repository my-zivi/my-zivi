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
        format.json do
          render :show
        end
        format.xml do
          send_data generate_pain, disposition: 'attachment',
                                   filename: I18n.t('payment.pain_filename',
                                                    from_date: I18n.l(@payment.payment_timestamp, format: '%d.%m.%Y'))
        end
      end
    end

    def index
      @payments = Payment.all
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

    private

    def payment_timestamp_param
      Time.zone.at(params[:payment_timestamp].to_i)
    end

    def generate_pain
      PainGenerationService.new(@payment.expense_sheets).generate_pain.to_xml('pain.001.001.03.ch.02')
    end
  end
end
