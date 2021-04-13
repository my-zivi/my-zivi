# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sys_admin/blog_entries/index', type: :view do
  before do
    assign(:sys_admin_blog_entries, [
             SysAdmin::BlogEntry.create!(
               title: 'Title',
               body: 'MyText',
               author: 'Author'
             ),
             SysAdmin::BlogEntry.create!(
               title: 'Title',
               body: 'MyText',
               author: 'Author'
             )
           ])
  end

  it 'renders a list of sys_admin/blog_entries' do
    render
    assert_select 'tr>td', text: 'Title'.to_s, count: 2
    assert_select 'tr>td', text: 'MyText'.to_s, count: 2
    assert_select 'tr>td', text: 'Author'.to_s, count: 2
  end
end
