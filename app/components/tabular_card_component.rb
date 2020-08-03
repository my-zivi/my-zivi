# frozen_string_literal: true

class TabularCardComponent < ViewComponent::Base
  with_content_areas :actions

  def initialize(title:, table_content:)
    @title = title
    @table_content = table_content
  end

  def self.humanize_table_values(values_klass, **information_table)
    information_table
      .select { |_key, value| value.present? }
      .transform_keys(&values_klass.method(:human_attribute_name))
  end
end
