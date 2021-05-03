# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sys_admins/blog_entries/edit', type: :view do
  let(:blog_entry) { create(:blog_entry) }

  before do
    assign(:blog_entry, blog_entry)
    render
  end

  it 'renders the edit blog_entry form' do
    assert_select 'form[action=?][method=?]', sys_admins_blog_entry_path(blog_entry), 'post' do
      assert_select 'input[name=?]', 'blog_entry[title]'
      assert_select 'input[name=?]', 'blog_entry[content]'
      assert_select 'input[name=?]', 'blog_entry[author]'
      assert_select 'input[name=?]', 'blog_entry[description]'
      assert_select 'input[name=?][type=checkbox]', 'blog_entry[published]'
    end
  end
end
