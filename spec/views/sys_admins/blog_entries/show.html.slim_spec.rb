# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sys_admins/blog_entries/show', type: :view do
  let(:blog_entry) { build(:blog_entry, id: 1) }

  before do
    assign(:blog_entry, blog_entry)
    render
  end

  it 'renders attributes' do
    expect(rendered).to include blog_entry.title
    expect(rendered).to include blog_entry.content.to_plain_text
    expect(rendered).to include blog_entry.author
  end
end
