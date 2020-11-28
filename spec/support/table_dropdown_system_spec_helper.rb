# frozen_string_literal: true

def click_dropdown_element(element)
  find('button.dropdown-toggle').click
  find(element).click
end

def click_dropdown_element_within(outer_element, element)
  within outer_element do
    click_dropdown_element(element)
  end
end
