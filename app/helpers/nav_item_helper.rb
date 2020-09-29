# frozen_string_literal: true

module NavItemHelper
  def nav_item_class(nav_path)
    return 'active' if current_page?(nav_path)

    ''
  end
end
