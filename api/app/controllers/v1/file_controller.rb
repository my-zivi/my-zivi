# frozen_string_literal: true

module V1
  class FileController < ApplicationController
    include V1::Concerns::ParamsAuthenticatable

    before_action :authenticate_from_params!
  end
end
