# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sys_admins/blog_entries/index', type: :view do
  let(:blog_entries) { [build(:blog_entry, slug: 'slug-1'), build(:blog_entry, slug: 'slug-2')] }

  before do
    assign(:blog_entries, blog_entries)
    render
  end

  it 'renders a list of blog_entries' do
    assert_select 'tr>td', text: blog_entries.first.title, count: 1
    assert_select 'tr>td', text: blog_entries.second.title, count: 1
  end
end
