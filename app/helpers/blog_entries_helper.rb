# frozen_string_literal: true

module BlogEntriesHelper
  def tags_filter_menu_items(filter_params)
    menu_items = BlogEntry::SUPPORTED_TAGS.map do |blog_entry_tag|
      tag_selected = filter_params[:tags].include?(blog_entry_tag)
      link_to(filter_path(blog_entry_tag, filter_params, tag_selected), class: 'dropdown-item') do
        concat(
          tag.div(class: 'd-inline-block mr-2', style: 'width: 14px') do
            tag.i(class: 'fas fa-check mr-2') if tag_selected
          end
        )
        concat I18n.t(blog_entry_tag, scope: 'activerecord.arrays.blog_entry.tags')
      end
    end

    safe_join(menu_items)
  end

  private

  def filter_path(blog_entry_tag, filter_params, tag_selected)
    new_tags = tag_selected ? filter_params[:tags] - [blog_entry_tag] : filter_params[:tags] + [blog_entry_tag]
    params.permit(:controller, :action).merge({ filter: filter_params.merge(tags: new_tags.empty? ? [''] : new_tags) })
  end
end
