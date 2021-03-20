# frozen_string_literal: true

class CardAccordionEntryComponent < ViewComponent::Base
  def initialize(title:, parent_id:, expanded: false)
    @title = title
    @parent_id = parent_id
    @expanded = expanded

    super
  end

  private

  def dom_id
    "entry-#{Digest::MD5.hexdigest(@title)[..10]}"
  end

  def heading_id
    "heading-#{dom_id}"
  end
end
