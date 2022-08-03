# frozen_string_literal: true

module NavbarHelper
  DROPDOWN_ITEM = Struct.new(:name, :path) do
    include ActionView::Helpers::UrlHelper

    def html(is_current_page)
      link_to(name, path, class: "dropdown-item #{is_current_page ? 'active font-weight-bold' : ''}")
    end
  end.freeze

  def navbar_link(name, path)
    tag.li(class: "nav-item #{current_page?(path) ? 'active font-weight-bold' : ''}".squish) do
      link_to(name, path, class: 'nav-link')
    end
  end

  def dropdown_navbar_link(name, path, *dropdown_items)
    tag.li(class: "nav-item dropdown #{current_page?(path) ? 'active font-weight-bold' : ''}".squish) do
      concat link_to(name, path,
                     class: 'nav-link dropdown-toggle',
                     role: 'button',
                     'data-toggle': 'dropdown',
                     'aria-expanded': 'false')
      concat(tag.div(class: 'dropdown-menu dropdown-menu-card dropdown-caret mt-0') do
        tag.div(class: 'bg-white py-2') do
          safe_join(dropdown_items.map { |item| item.html(current_page?(item.path)) })
        end
      end)
    end
  end

  def dropdown_item(name, path)
    DROPDOWN_ITEM.new(name, path)
  end
end
