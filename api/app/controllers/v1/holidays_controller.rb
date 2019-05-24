# frozen_string_literal: true

module V1
  class HolidaysController < APIController
    before_action :set_holiday, only: %i[update destroy]

    def index
      @holidays = Holiday.all
    end

    def create
      @holiday = Holiday.new(holiday_params)

      raise ValidationError, @holiday.errors unless @holiday.save

      render :show, status: :created
    end

    def update
      raise ValidationError, @holiday.errors unless @holiday.update(holiday_params)

      render :show
    end

    def destroy
      raise ValidationError, @holiday.errors unless @holiday.destroy
    end

    private

    def set_holiday
      @holiday = Holiday.find(params[:id])
    end

    def holiday_params
      params.require(:holiday).permit(:beginning, :ending, :holiday_type, :description)
    end
  end
end
