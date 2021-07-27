# frozen_string_literal: true

module ActionTextJobPosting
  RICH_TEXT_ATTRIBUTES = %w[description required_skills preferred_skills].freeze
end

ActiveSupport.on_load(:action_text_rich_text) do
  ActionText::RichText.class_eval do
    before_save :record_change

    private

    def record_change
      return unless body_changed?
      return unless ::ActionTextJobPosting::RICH_TEXT_ATTRIBUTES.include?(name) && record_type == 'JobPosting'

      # rubocop:disable Rails/SkipsModelValidations
      record.touch
      # rubocop:enable Rails/SkipsModelValidations
    end
  end
end
