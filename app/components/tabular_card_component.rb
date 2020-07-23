# frozen_string_literal: true

class TabularCardComponent < ViewComponent::Base
  with_content_areas :actions

  def initialize(title:, table_content:)
    @title = title
    @table_content = table_content
  end
end
