# frozen_string_literal: true

module V1
  class FileController < ApplicationController
    include V1::Concerns::ParamsAuthenticatable

    before_action :authenticate_from_params!

    protected

    def render_pdf(filename:, pdf:)
      response.set_header('Content-Disposition', "inline; filename=#{filename}")
      render plain: pdf
    end
  end
end
