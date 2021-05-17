# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sys_admins/blog_entries/new', type: :view do
  let(:blog_entry) { build(:blog_entry) }

  before do
    assign(:blog_entry, blog_entry)
    render
  end

  it 'renders new blog_entry form' do
    assert_select 'form[action=?][method=?]', sys_admins_blog_entries_path, 'post' do
      assert_select 'input[name=?]', 'blog_entry[title]'
      assert_select 'input[name=?]', 'blog_entry[content]'
      assert_select 'input[name=?]', 'blog_entry[author]'
      assert_select 'input[name=?]', 'blog_entry[description]'
      assert_select 'input[name=?][type=checkbox]', 'blog_entry[published]'
    end
  end
end
