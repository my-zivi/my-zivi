require 'rails_helper'

RSpec.describe "sys_admin/blog_entries/edit", type: :view do
  before(:each) do
    @blog_entry = assign(:blog_entry, SysAdmin::BlogEntry.create!(
      title: "MyString",
      body: "MyText",
      author: "MyString"
    ))
  end

  it "renders the edit blog_entry form" do
    render

    assert_select "form[action=?][method=?]", blog_entry_path(@blog_entry), "post" do

      assert_select "input[name=?]", "blog_entry[title]"

      assert_select "textarea[name=?]", "blog_entry[body]"

      assert_select "input[name=?]", "blog_entry[author]"
    end
  end
end
