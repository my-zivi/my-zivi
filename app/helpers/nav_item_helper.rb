# frozen_string_literal: true

module NavItemHelper
  def nav_item_class(nav_path)
    # debugger
    return 'active' if breadcrumb_trail.to_a.any? { |breadcrumb| breadcrumb.path == nav_path }

    ''
  end
end
