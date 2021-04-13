require 'rails_helper'

RSpec.describe "sys_admin/blog_entries/new", type: :view do
  before(:each) do
    assign(:blog_entry, SysAdmin::BlogEntry.new(
      title: "MyString",
      body: "MyText",
      author: "MyString"
    ))
  end

  it "renders new blog_entry form" do
    render

    assert_select "form[action=?][method=?]", sys_admins_blog_entries_path, "post" do

      assert_select "input[name=?]", "blog_entry[title]"

      assert_select "textarea[name=?]", "blog_entry[body]"

      assert_select "input[name=?]", "blog_entry[author]"
    end
  end
end
