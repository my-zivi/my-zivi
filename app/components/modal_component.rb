# frozen_string_literal: true

class ModalComponent < ViewComponent::Base
  with_content_areas :body

  def initialize(modal_id:, title:)
    @modal_id = modal_id
    @title = title
  end
end
