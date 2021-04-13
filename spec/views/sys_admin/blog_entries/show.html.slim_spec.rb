require 'rails_helper'

RSpec.describe "sys_admin/blog_entries/show", type: :view do
  before(:each) do
    @blog_entry = assign(:blog_entry, SysAdmin::BlogEntry.create!(
      title: "Title",
      body: "MyText",
      author: "Author"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Author/)
  end
end
