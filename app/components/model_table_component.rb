# frozen_string_literal: true

class ModelTableComponent < ViewComponent::Base
  def initialize(model_data:, model_columns:, model_actions: {})
    @model_data = model_data
    @model_columns = model_columns
    @model_actions = model_actions

    super
  end
end
